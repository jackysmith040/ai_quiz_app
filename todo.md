## Quiz App Powered by AI

> Side idea we can adapt it to a chrome extension to learn on the go

## Overview:
Generates multiple choice questions from lecture notes or slides or text


## Parts:
Paste: User can paste the text and get questions generated
Upload: User can add lecture notes or slides

## Nice Controls:
Number of questions: User can specify the number of questions that should be generated (limit 100)
Difficulty level: User can specify level of difficulty (Easy, Medium, Hard, Exam Madness)
Auto: Allow AI to choose (by default: 15 questions)
* Bring More: Generate additional question

## Flow:

> Flow for the Paste

Paste text (limit 500 characters)
Hit Generate button (Ctrl+Enter)
Routes to a page with the generated questions (Knust Exam Style) shows the number of questions and allows you to jump to each question
When the user selects a question, it marks it secretly and stores it and add up as you answer to minimise scoring time
There's a review feature that displays the Questions with the answers.


> Flow for the Upload

Paste Upload (limit 5mb)
Hit Generate button (Ctrl+Enter)
Routes to a page with the generated questions (Knust Exam Style) shows the number of questions and allows you to jump to each question
When the user selects a question, it marks it secretly and stores it and add up as you answer to minimise scoring time
There's a review feature that displays the Questions with the answers.


## Special Feature:
Converts the questions and answers to pdf so you can learn later
Renders Math well
Exam-Ready Prompts in the background, no need to write prompts

## Future Features:
Audio Assistant
Timer feature to simulate real exams
Can select and type custom prompts
Authentication


## Services
AI Quiz App
AI Note App
AI PDF to Voice App


## API
OpenAI ChatGPT (for now)
Llama 4 (if i figure it out)

## Schema

# Response Schema
Questions {
  Question: string,
  Answer: string,
  Choices: list[string] {
    a: string,
    b: string,
    c: string,
    d: string,
  }
  Explanation: long text
}

# Request Schema
Info {
  Prompts: list[long text],
  TextInfo: string (long text),
  NumberofQuestions: int, default: 15
  DifficultyLevel: Easy | Medium | Hard | Exam Madness, default: Easy and Medium
}




