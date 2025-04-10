# quizState.imba
import { api_state } from './homeState';
import { generateQuiz } from './aiApiState.js';
import {updateQuiz} from '../quiz'

# Export the quizInfo state as a reactive object
export let quizInfo = {
	questions: [],
	isLoading: false,
	error: null,
};

# Function to fetch and populate quiz questions
export def fetchQuizQuestions
	quizInfo.isLoading = true;
	quizInfo.error = null;

	const userInput = {
			textInfo: api_state.textInfo || "Photosynthesis is the process by which green plants convert light energy into chemical energy.",
			numberOfQuestions: api_state.numberOfQuestions || 5,
			difficultyLevel: api_state.difficultyLevel || "Medium",
	};

	try
			# Generate quiz questions using the AI API
			const quizQuestions = await generateQuiz(userInput);
			imba.commit!
			# quizInfo.questions = quizQuestions; # Update the state
			updateQuiz(quizQuestions)
			# console.log('Generated Quiz Questions:', quizInfo.questions);
	catch error
			quizInfo.error = error.message; # Store the error
			console.error('Error generating quiz:', error.message);
	finally
			quizInfo.isLoading = false; # Reset loading state

# Export a helper function to reset the quiz state
export def resetQuiz
	quizInfo.questions = [];
	quizInfo.isLoading = false;
	quizInfo.error = null;