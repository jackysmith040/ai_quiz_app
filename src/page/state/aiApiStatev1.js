import { GoogleGenAI } from '@google/genai';

const GEMINI_API_KEY = "AIzaSyA_YMI6-sTIdOftmMtB8ZhuezNO1lmncIM";

// Configure the client
const genAI = new GoogleGenAI({ apiKey: process.env.GEMINI_API_KEY || GEMINI_API_KEY });

// Helper Function to Format Quiz Schema
function formatQuizResponse(responseData) {
  const questions = [];
  const rawQuestions = responseData.split('\n\n'); // Assuming questions are separated by double newlines

  rawQuestions.forEach((rawQuestion, index) => {
    if (!rawQuestion.trim()) return; // Skip empty lines

    // Split the raw question into lines and clean them
    const lines = rawQuestion.split('\n').map(line => line.trim()).filter(line => line);

    // Extract individual components using regex for flexibility
    const questionMatch = lines.find(line => /^Question:/i.test(line));
    const answerMatch = lines.find(line => /^Answer:/i.test(line));
    const choicesMatch = lines.find(line => /^Choices:/i.test(line));
    const explanationMatch = lines.find(line => /^Explanation:/i.test(line));

    // Validate that all required components are present
    if (!questionMatch || !answerMatch || !choicesMatch || !explanationMatch) {
      console.warn(`Skipping malformed question at index ${index}:`, rawQuestion);
      return;
    }

    // Extract and clean the components
    const question = questionMatch.replace(/^Question:/i, '').trim();
    const answer = answerMatch.replace(/^Answer:/i, '').trim();
    const choices = choicesMatch.replace(/^Choices:/i, '').trim();
    const explanation = explanationMatch.replace(/^Explanation:/i, '').trim();

    // Parse choices into an array
    const choiceArray = choices.split(',').map(choice => choice.trim());

    // Validate that we have exactly 4 choices
    if (choiceArray.length !== 4) {
      console.warn(`Skipping question with invalid choices at index ${index}:`, rawQuestion);
      return;
    }

    // Push formatted question into the array
    questions.push({
      id: index + 1,
      question,
      answer,
      choices: {
        a: choiceArray[0],
        b: choiceArray[1],
        c: choiceArray[2],
        d: choiceArray[3],
      },
      explanation,
      isSelected: false, // Add isSelected property with default value of false
    });
  });

  return questions;
}

// Main Function to Generate Quiz Questions
export async function generateQuiz({ textInfo, numberOfQuestions = 15, difficultyLevel = 'Easy' }) {
  try {
    // Construct Prompt Based on User Input
    const prompt = `
      Generate ${numberOfQuestions} multiple-choice questions based on the following text:
      "${textInfo}"

      Difficulty Level: ${difficultyLevel}
      Format each question as follows:
      Question: <question>
      Answer: <correct_answer>
      Choices: <option_a>, <option_b>, <option_c>, <option_d>
      Explanation: <explanation>

      Ensure questions are unique, clear, and exam-ready.
    `;

    // Generate content using the model
    const result = await genAI.models.generateContent({
      model: 'gemini-2.0-flash',
      contents: prompt,
    });

    // Extract the response text
    const responseData = result.text;

    // Debugging: Log the raw response for inspection
    console.log('Raw API Response:', responseData);

    // Parse and Format Response
    const formattedQuestions = formatQuizResponse(responseData);

    return formattedQuestions;
  } catch (error) {
    console.error('Error generating quiz:', error.message);
    throw new Error('Failed to generate quiz. Please try again.');
  }
}