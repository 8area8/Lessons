#HOW TO CONFIGURE SUBLIMTEXT 3 TO RECOGNIZE THE GOOD PYTHON INTERPRETER?

From various *VENVs*, i need to recognize the good python path to work with the good python interpreter.

##WHY DO I NEED IT?

Here, some reasons:
1. I use the package *Anaconda* in ST3, and it can recognize every library/framework from the python interpreter and can display the documentations.
	But for that, i need to have the good python interpreter, not the basic one.
2. If i want to open a SHELL into ST3, i need the good path (or I'll get some path error!). But, actually, i never use this tool.
3. If i use the second python version, I'll get some syntax error.

##HOW TO

[The nice stackoverflow post](https://stackoverflow.com/questions/24963030/sublime-text3-and-virtualenvs)

>note: I only use **anaconda** plugin for linter autocompletion and doc popup.

Then, I create a SublimText project that I edit, and change the python_interpreter path to my python venv.

```
,
	"settings":
	{
		"python_interpreter": "C:\\Users\\mbrio\\.virtualenvs\\project3\\Scripts\\python"
	}
```

Anaconda use that variable to work with the python interpreter.