let waiting_seconds = 0
let intervalId = null

# Start the countdown timer
def timer
	if !intervalId
		intervalId = setInterval(&, 1000) do
			waiting_seconds = waiting_seconds + 1
			if waiting_seconds >= 10
				clearInterval(intervalId)
				intervalId = null
				# waiting_seconds = 0


# Start the timer when the component mounts
export tag Loading
	def mount
		timer()
	<self[d:vcc w:100% h:100vh]>
		<div[s:50rem bxs:lg rd:full d:vcc m:6rem]>
			<h1> "We are generating the quiz"
			<h5> "Chill and let the easy learning take place"
				
			if waiting_seconds < 10
					<p[fs:4xl fw:700]> waiting_seconds
			else
				<button route-to='/quiz' @click=(waiting_seconds=0)> "Click here to see the quiz"
				