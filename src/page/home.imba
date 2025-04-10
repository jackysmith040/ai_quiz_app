import '../assets/textarea.css'
import {app_state, api_state} from './state/homeState'
import {fetchQuizQuestions } from './state/quizState'

let textarea_value=api_state.textInfo 
let input_value=api_state.numberOfQuestions
let levelOfDifficulty = api_state.difficultyLevel

def set_api_info
	api_state.textInfo = textarea_value
	api_state.numberOfQuestions = input_value
	api_state.difficultyLevel = levelOfDifficulty  
	fetchQuizQuestions()
	return "setup"


export tag Home
	css .textarea_style w:32rem overflow:hidden bgc:#FFF c:#222 ff:Courier, monospace 
		fs:24px resize:vertical lh:40px px:100px py:80px
		bgi:url(https://static.tumblr.com/maopbtg/E9Bmgtoht/lines.png), url(https://static.tumblr.com/maopbtg/nBUmgtogx/paper.png) bgr:repeat-y, repeat 
		rd:12px bs:0px 2px 14px #000 bdt:1px solid #FFF bdb:1px solid #FFF	
	
	css .select_style w:100% p:10px fs:16px rd:4px bd:1px solid #ccc bgc:#fff c:#333 mb:1rem

	<self[m:8vh d:vcc]>
		<%headings[d:vcc mb:3rem]>
			<%logo[fs:5xl]> app_state.logo
			<h1> app_state.title
			<h3[fs:1em c:gray5]> app_state.subtitle
		<%question-prompt[s:fit-content d:vcc w:700px mb:100px]>
			<%margin[ml:12px mb:20px user-select:none]>
					"Number of Questions:" 
					<input id="num_quiz" type="number" name="num_quiz" bind=input_value [bgc:transparent bdb:3px solid #FFF fs:20px ff:Courier, monospace fw:bold w:220px h:28px]>
					if textarea_value
						<button[ml:1rem p:12px 24px fs:16px fw:700 c:cool0 bgc:blue4 bd:none rd:md cursor:pointer bxs:md y@in:100px o@out:0] ease> 
							<a route-to='/loading' @click=set_api_info>
								"Generate Quiz"
			<textarea[bgc:transparent bd:none] bind=textarea_value 
			placeholder="Paste your question(s)" .textarea_style role="textbox" aria-autocomplete="list" aria-haspopup="true">
			<div [d:hbs g:30rem]>
				<select.select_style bind=levelOfDifficulty> for df in app_state.difficulty_control
					<option value=df> df
				<div.select_style[c:green6 fw:700] [c:red6]=(textarea_value.length > app_state.max_characters)>
						"{textarea_value.length} / {app_state.max_characters}"
		


