#Why create a project?

1. 	With project, you can open easily a folder and switch to another project with the ```project/Switch_project``` command.
2. 	You can set the *python_interpreter* variable in the project setting ```project/Edit_project``` to use a sepecifique virtualenv.
	Look for *Sublim_text_support* from *Python/virtual_environnement*.
3. 	better organization.

##1 CREATE A PROJECT

Create an *empty* project: **CTRL+MAJ+N** -> new window, *project/Save_Project_as*
>You can also use ```add folder to project```.

##2 SAVE THE PROJECT

I created a specific folder for the project's files:
>C:\Users\mbrio\Documents\SublimeText_project_files

If I moove my project folder, the file is still recognized by ST3.

##3 KEY BINDING

I added the followed key in my **Preferences/Key_Binding** file:
>{ "keys": ["ctrl+alt+p"], "command": "prompt_select_workspace" }

Then a can quick switch with *CTRL+ALT+P*.