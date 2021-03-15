

![caddy](images/caddy.png) 

# Parse Caddy - A visual parse rule checker     

What's Parse?

From red-lang.org

"So, in short, what is Parse? It is an embedded DSL (we call them "dialects" in the Rebol world) for parsing input series using grammar rules. The Parse dialect is an enhanced member of the TDPL family. Parse's common usages are for checking, validating, extracting, modifying input data or even implementing embedded and external DSLs."

[Overview here.](https://www.red-lang.org/search?q=parse)

[Full documentation here.](https://github.com/red/docs/blob/master/en/parse.adoc)

----

## Tool usage

* Type in your input. 
- Modify Input Field is recommended, otherwise watch the "Remaining input:" text for changes.


![input](images/input.gif)

----

* Type in your rule. 

- The tool will check if the rule passes or fails as you type. Clearing the field will reset some things :)

![rule](images/rule.gif)

----

* Check to parse Block values.

![block](images/blocks.gif)

----

* Type in multiple parse rules here.

![multi](images/multi.png)

- Click the Load Rules button.

* Use them in the Rule field

![multi-2](images/multi.gif)

-----

**CAUTION**

In the current version of the tool, anything in the Multiple Rules area will be loaded and executed by the Red language if you click Load Rules. 

Be careful.

----

**Log**

<!-- * There's a Log area for those who like logs. -->
- The buttons should be self explanatory, but let me know if you have questions.

![log](images/log.png)

----

**Samples**

* Moving positions

![sample](images/sample.gif)