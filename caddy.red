Red [
    Needs: 'View
    Author: ["Greg Tewalt"]
]

r: none ; compiler complains about the word t, specifically, so declaring it here to get it to compile

pic: load/as #do keep [read/binary %caddy.png] 'png    ;-- owe rubles?

context [

	clear-output: func [areas [block!]][foreach a areas [face: get a face/data: copy ""]]

        reset-all: does [i/data: copy "" r/data: copy "" reset-field? r t/data: false]

	reset-field?: func [fld][
		if none? fld/data [fld/color: white clear-output [fetch-txt match-txt end-txt]]
	]
  
	convert-to-block-vals?: func [fld] [
		either true = t/data [to-block fld/text][fld/text]
	]

        ; on-parse-event taken from environment/functions.red, and modified
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
			paren [] ; after evaluation of paren! expression
			push  [] ; after rule is pushed on the stack
			pop [
			         ; before rule is popped from the stack
			    match-txt/data: reduce [
					"Match?" match? newline
					"Remaining input:" input newline
					"At index:" index? input 
				]
			]
			fetch [ ; before a new rule is fetched
				fetch-txt/data: reduce [
					"Input:"    mold/flat/part input 50 newline
					"Rule:"     mold/flat/part rule  50 newline
				]
			]
			match [ ; after a value has matched
				either match? = true [
					r/color: 102.255.102  ; shade of green
				][
					r/color: 255.51.51    ; shade of red
					clear-output [match-txt] 
				]  
			]
			end   [end-txt/data: reduce ["Parse return:" match?]] ; after reaching end of input
		]
		true
	]
    
    view compose [
		title "Parse Caddy"
    		size 800x600
    		backdrop wheat
    		style my-field: field 500x40 font [name: "Segoe UI" size: 14 color: black]
    		style my-text:  text  500x90 font [name: "Segoe UI" size: 16 color: black]
    		at 510x30 t: toggle "Parse Block Values" on-change [(r/data: copy "" reset-field? r)]
    		at 680x30 b: button "Reset" [(reset-all)]
    		at 50x70  h4 "Input"
    		at 50x100 i: my-field 700x40 linen 
    		at 50x170 h4 "Rule"
    		at 50x200 r: my-field 700x40 linen on-change [
			    attempt [(parse/trace convert-to-block-vals? i to-block r/text :on-parse-event reset-field? r)]
			] 
    		at 55x275 fetch-txt: my-text 
    		at 55x345 match-txt: my-text
    		at 55x435 end-txt: my-text
                at 645x320 image pic
	]
]