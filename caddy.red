Red [
	Needs: 'View
	Title:  "Parse Caddy"
	Author: "Greg Tewalt"
	File: %caddy.red
]

r: none ; compiler complains about the word t, specifically, so declaring it here to get it to compile

#include %mascot.red

context [
	
	check: does [
		attempt [
			(parse/trace convert-to-block-vals? i to-block r/text :on-parse-event reset-field? [r] populate-log)
		]
	]

	clear-output: func [areas [block!]][foreach a areas [face: get a face/data: copy ""]]

	convert-to-block-vals?: func [fld] [
		either true = t/data [to-block fld/text][fld/text]
	]

	load-multi-rule: does [attempt [do load _mr/text]]

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
					"At index:" index? input newline
				]
				either match? = true [
					r/color: 102.255.102  	      ; turn a shade of green
					if any [t/data = false t/data = none][                         ; if we're not parsing block values,
						_i/selected: to pair! rejoin [index? input 'x index? input] ; select index of match in Input field
					]
					if true = mt/data [
						_i/text: head input    ; if "input" changes, update the text in the Input field
					]
				][
					clear-output [match-txt] 
					; red color is taken care of in the fetch event
				]
			]
			fetch [ ; before a new rule is fetched
				fetch-txt/data: reduce [
					"Input:"    mold/flat/part input 50 newline
					"Rule:"     mold/flat/part rule 50 newline
				]
				r/color: 255.51.51  ; shade of red
				_i/selected: none
			]
			match [] ; after a value has matched
			
			end [    ; after reaching end of input
				end-txt/data: reduce ["Parse return:" match?]
			] 
		]
		true
	]
	
	populate-log: does [
		log/text: ""
		append log/text rejoin [
			   newline "***" newline form fetch-txt/data form match-txt/data form end-txt/data newline "***" newline
		]
	]

	reset-all: does [
		_i/data: copy "" 
		r/data: copy "" 
		reset-field? [r _i] 
		t/data: false 
		mt/data: false
		reset-log
		reset-mutli
	]

	reset-field?: func [flds [block!]][
		foreach f flds [
			face: get f 
			if none? face/data [
				face/color: white 
				clear-output [fetch-txt match-txt end-txt] 
				_i/selected: none 
			]
		]
	]
  
	reset-log:   does [clear log/text]

	reset-mutli: does [clear _mr/text]

	scan: func [fld][ ; Used for Block mode. illegal characters cause the field data to be none, as if empty
		either none = fld/data [
			fetch-txt/data: {"In Block Mode, watch out for empty Input, or illegal characters like , and \."}
				clear-output [match-txt end-txt]
			r/color: white
		][
			fetch-txt/data: copy ""
		]
	]

	;-- Begin VID data ---------------------------------------------------------------------------------------------------
    ; --
	home: [

		size 80x600
		backdrop wheat
		style my-field: field 500x40  font [name: "Segoe UI" size: 14 color: black]
		style my-text:  text  500x90  font [name: "Segoe UI" size: 16 color: black]
		at 50x30  mt:   check "Modify Input Field" on-change [(r/data: copy "" reset-field? [r _i])]
		at 200x30 t:    check "Parse Block Values" on-change [(r/data: copy "" reset-field? [r _i])]
		at 635x30 b:    button "Reset Caddy" [(reset-all)]
		at 50x70  h4 "Input"
		at 50x100 _i: my-field 700x40 on-change [(if t/data = true [scan _i])]
		at 50x170 h4 "Rule"
		at 50x200 r: my-field 700x40 on-change [(check)] 
		at 55x275 fetch-txt: my-text 
		at 55x360 match-txt: my-text
		at 55x445 end-txt:   my-text
		at 645x320 image img 
	]

	multi-rule: [
		size 800x600
		backdrop wheat 
		style my-area: area 710x450 font [name: "Segoe UI" size: 14 color: black]
		at 50x30  button "Load Rules"  [load-multi-rule]
		at 650x30 button "Clear Rules" [reset-mutli]
		at 50x70  h4 "Enter Multiple Rules" 
		at 50x100 _mr: my-area
	]


	log: [
		size 800x600
		backdrop wheat 
		style my-area: area 710x450 font [name: "Segoe UI" size: 14 color: black]
		at 50x30  button "Select All" [
			unless none? log/text [log/selected: to pair! rejoin [1 'x (length? log/text) + 1]]
		]
		at 150x30 button "Copy" [
			unless none? log/selected [write-clipboard copy/part log/text log/selected]
		]
		at 580x30 button "Save" [
			attempt [write rejoin [request-dir now "-caddy-log.txt"] log/text]
		]
		at 650x30 button "Clear Log" [(reset-log)]
		at 50x70  h4 "Log file" 
		at 50x100 log: my-area 
	]

		view compose/deep [
		title "Parse Caddy"
			tab-panel ["Home" [(home)] "Multi Rule" [(multi-rule)] "Log" [(log)]]
	]
]