import { quizInfo } from './state/quizState';
import {fetchQuizQuestions} from './state/quizState'

# Ensure the quiz state is initialized when the component loads

let questions

let selected = ""
let shouldExplain? = no
let id = 0

export def updateQuiz(quizUpdates)
	questions = quizUpdates
	console.log(questions)


def check_selected(id)
	if questions && questions.length > 0
		for que in questions
			if que.id == id
				que.isSelected = !que.isSelected
			else 
				que.isSelected = no

def previous(qid)
	id = qid - 1
	check_selected(id)

def next(qid)
	id = qid + 1
	check_selected(id)

def set_question(quiz_id)
	id = quiz_id
	check_selected(id)


tag left-section-box
	name
	title
	<self>
		<section[px:2rem py:1rem bgc:white rd:lg]>
			<p> name
			<hr>
			<p> title

tag left-section
	<self[d:vflex flex:0 0 350px rd:lg g:4]>
		<question-tracker>
		<left-section-box name="AfriQuiz" title="Learning Made Easy">
		<left-section-box name="Test" title="Quiz Title">

tag right-section
	<self[flex:1 rd:lg p:1rem ml:1rem]>
		<quiz-body>

tag question-tracker
	<self[px:1.2rem py:1rem bgc:white rd:lg]>
		<h3> "Questions"
		<ul[d:grid gtc:repeat(auto-fill, minmax(40px, 1fr)) g:5px ai:center jc:center p:2px]>
			if questions && questions.length > 0
				for que in questions
						<li[list-style:none us:none c:gray8 rd:lg p:0.5rem d:vcc ai:center jc:center bgc:gray2] 
						[bgc: green4]=que.isSelected @click=set_question(que.id)> que.id
			<hr>
		<p[c@hover:red6]> "Submit Quiz"

tag quiz-buttons
	quiz_id\number
	<self>
		id = quiz_id
		# Navigation Buttons
		<div [d:flex jc:space-between w:100% mt:2rem g:35rem]>
			<button [bgc:#007BFF c:white rd:4px py:0.5rem px:1rem fs:1rem]@click=previous(id)> "Previous"
			<button [bgc:#007BFF c:white rd:4px py:0.5rem px:1rem fs:1rem]@click=next(id)> "Next"

tag quiz-body
	<self[flex:1 bgc:#ffffff rd:12px p:2rem ml:1rem bs:0px 2px 4px rgba(0, 0, 0, 0.1) d:vcc ai:center]>
		if questions && questions.length > 0
			for que in questions
				if que.id == id
					<quiz-buttons quiz_id=que.id>

					# Quiz Header	
					<div [fw:bold fs:1.5rem mb:1rem]>
							"All the best"

					# Quiz Question
					<div [mb:2rem]>
							que.question

					# Quiz Options
					<div>
						for option in que.choices
							<div [mb:1rem ease:0.5s py:1.25rem px:10rem rd:xl bgc:#f9f9f9 br:8px bs:0px 4px 8px rgba(0, 0, 0, 0.1) 
							transition:transform 0.3s ease, bs 0.3s ease bxs@hover:0px 8px 16px rgba(0, 123, 255, 0.3) 
							scale@hover:1.05] [bgc:green5]=(selected==que.answer and option==selected) [bgc:rose6]=(selected!=que.answer and selected and option==selected)>
								<label[c:#333 fs:1rem d:flex ai:center]>
									<input type="radio" name="option" value=option bind=selected>
									<span [ml:0.75rem opacity@off:0 y@off:-10px transition:opacity 0.3s ease, transform 0.3s ease]> option
						
						<p[c@hover:rose7 fs:2xl fw:600] @click=(shouldExplain?=!shouldExplain?)> "Explain"
						if shouldExplain?
							<h2> que.explanation

export tag Quiz
	<self[d:vgrid h:100vh]>
		<div[w:100vw bgc:white]>
			<p[fw:600 c@hover:blue9 fs:1.5rem ml:2rem] route-to='/'> "Return to home page"
		<main[d:flex flex:1 m:1rem ai:stretch]>
			<left-section>
			<right-section>
			