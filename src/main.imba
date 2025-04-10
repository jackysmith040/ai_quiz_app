import {Home} from './page/home'
import {Quiz} from './page/quiz'
import {Loading} from './page/loading'


global css body bgc:cool3 m:0

tag App

	<self>
		<Home route='/'>
		<Loading route='/loading' autorender=1s>
		<Quiz route='/quiz'>

imba.mount <App>


