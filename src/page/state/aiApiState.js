import { GoogleGenAI } from '@google/genai';

const GEMINI_API_KEY = "AIzaSyA_YMI6-sTIdOftmMtB8ZhuezNO1lmncIM";
const genAI = new GoogleGenAI({ apiKey: process.env.GEMINI_API_KEY || GEMINI_API_KEY });

/**
 * Formats raw API response into a structured quiz schema
 */
function formatQuizResponse(responseData) {
  const questions = [];
  let cleanedResponse = responseData.trim();

  // Remove all markdown code block syntax (```json ... ```)
  cleanedResponse = cleanedResponse.replace(/```(json)?/g, '').trim();

  try {
    // Parse JSON (handle both array and single-object responses)
    const parsedData = JSON.parse(cleanedResponse);
    const parsedQuestions = Array.isArray(parsedData) ? parsedData : [parsedData];
    console.log('Parsed Questions:', parsedQuestions);

    parsedQuestions.forEach((parsedQuestion, index) => {
      // Validate required fields
      if (
        !parsedQuestion.question ||
        !parsedQuestion.answer ||
        !parsedQuestion.choices ||
        parsedQuestion.choices.length !== 4 ||
        !parsedQuestion.explanation
      ) {
        console.warn(`Skipping invalid question at index ${index}:`, parsedQuestion);
        return;
      }

      // Validate choices are strings
      if (!parsedQuestion.choices.every(choice => typeof choice === 'string')) {
        console.warn(`Skipping question with invalid choices at index ${index}:`, parsedQuestion);
        return;
      }

      questions.push({
        id: index + 1,
        question: parsedQuestion.question.trim(),
        answer: parsedQuestion.answer.trim(),
        choices: [
          parsedQuestion.choices[0].trim(),
          parsedQuestion.choices[1].trim(),
          parsedQuestion.choices[2].trim(),
          parsedQuestion.choices[3].trim(),
        ],
        explanation: parsedQuestion.explanation.trim(),
        isSelected: false,
      });
    });
  } catch (error) {
    console.error('Parsing error:', error.message);
    throw new Error('Invalid API response format. Expected JSON array of questions.');
  }

  return questions;
}

/**
 * Generates a quiz from user input using Gemini API
 */
export async function generateQuiz({ textInfo, numberOfQuestions = 15, difficultyLevel = 'Easy' }) {
  try {
    // Strict prompt to prevent markdown wrapping
    const prompt = `
      Generate ${numberOfQuestions} multiple-choice questions in RAW JSON format with detailed and easy to understand explanation:
      - Do NOT use markdown or code blocks (\`\`\`)
      - Follow this structure EXACTLY:
        [
          {
            "question": "string",
            "answer": "string",
            "choices": ["string", "string", "string", "string"],
            "explanation": "string with detailed explanation of the answer in simple language" 
          },
        ]

      Text: "${textInfo}"
      Difficulty: ${difficultyLevel}
      Example:
        [
          {
            "question": "What is 2+2?",
            "answer": "4",
            "choices": ["3", "4", "5", "6"],
            "explanation": "Basic arithmetic."
          }
        ]
    `;

    const result = await genAI.models.generateContent({
      model: 'gemini-2.0-flash',
      contents: prompt,
    });

    console.log('Raw API Response:', result.text);
    return formatQuizResponse(result.text);
  } catch (error) {
    console.error('API Error:', error.message);
    throw new Error('Quiz generation failed. Please try again.');
  }
}