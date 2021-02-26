Red [
    Needs: 'View
]

context [
	
	clear-output: func [areas [block!]][foreach a areas [face: get a face/data: copy ""]]

    reset-all: does [i/data: copy "" r/data: copy "" reset-field? r t/data: false]

	reset-field?: func [fld][
		if none? fld/data [fld/color: white clear-output [fetch-txt match-txt end-txt]]
	]
  
	convert-to-block-vals?: func [fld] [
		either true = t/data [to-block fld/text][unless none? fld/data [form fld/data]]
	]

	on-parse-event: func [
		"Standard parse/trace callback used by PARSE-TRACE"
		event	[word!]   "Trace events: push, pop, fetch, match, iterate, paren, end"
		match?	[logic!]  "Result of last matching operation"
		rule	[block!]  "Current rule at current position"
		input	[series!] "Input series at next position to match"
		stack	[block!]  "Internal parse rules stack"
		return: [logic!]  "TRUE: continue parsing, FALSE: stop and exit parsing"
	][
		switch event [
			push [] ;
			pop	[
				; before rule is popped from the stack
				match-txt/data: reduce [
					"Match?" match? newline
					"Remaining input:" input newline
					"At index:" index? input 
				]
			]
			fetch [
				fetch-txt/data: reduce [
					"Input:"    mold/flat/part input 50 newline
					"Rule:"     mold/flat/part rule  50 newline
				]
			]
			match [
				either match? = true [
					r/color: green
				][
					r/color: Red 
					clear-output [match-txt] 
				]  
			]
			end   [end-txt/data: reduce ["Parse return:" match?]]
		]
		true
	]
    
	view compose [
    	title "The Pink Parse Tool"
    	size 800x450
    	backdrop pink
		style my-field: field 500x40 font [name: "DejaVu Sans" size: 12 color: black]
		style my-text:  text 500x60 bold font [name: "DejaVu Sans" size: 14 color: black]
		across
		t: toggle "Parse Block Data" right on-change [(r/data: copy "" reset-field? r)]
		b: button "Reset" [(reset-all)]
		return
		below
    	h4 "Input"
    	i: my-field 
    	h4 "Rule"
    	r: my-field on-change [(parse/trace convert-to-block-vals? i to-block r/text :on-parse-event reset-field? r)]
    	fetch-txt: my-text 
		match-txt: my-text
		end-txt:   my-text
	]
]
