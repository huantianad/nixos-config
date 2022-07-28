{ pkgs }:

{
    #############
    # General ##
    #############

    # Terminal Setup
    "terminal.external.linuxExec" = "/usr/bin/zsh";
    "terminal.integrated.fontFamily" = "MesloLGS NF";
    "terminal.integrated.env.linux" = {
      "PYTHONPATH" = "\${workspaceFolder}";
    };

    # "workbench.colorTheme" = "Purple Wolf Theme";
    "workbench.iconTheme" = "material-icon-theme";

    "editor.fontSize" = 14;
    # JetBrains Mono; MonoLisa; Fira Code
    # "editor.fontFamily" = "'Fira Code'; 'monospace'; monospace";
    "editor.fontFamily" = "Fira Code";
    "editor.fontLigatures" = true;

    "editor.guides.bracketPairs" = true;
    "editor.bracketPairColorization.enabled" = true;
    "editor.rulers" = [ 120 ];

    "editor.cursorBlinking" = "phase";
    "editor.cursorSmoothCaretAnimation" = true;
    "editor.smoothScrolling" = true;

    # Auto-suggest
    "editor.suggestSelection" = "first";
    "editor.inlineSuggest.enabled" = true;
    "editor.suggest.preview" = true;
    "editor.quickSuggestions" = {
      "strings" = true;
    };

    "explorer.confirmDelete" = false;
    "explorer.sortOrder" = "type";

    "files.autoSave" = "afterDelay";
    "files.autoSaveDelay" = 200;
    "files.trimTrailingWhitespace" = true;
    "debug.onTaskErrors" = "abort";
    "debug.terminal.clearBeforeReusing" = true;

    "files.exclude" = {
      "**/.git" = true;
      "**/.svn" = true;
      "**/.hg" = true;
      "**/CVS" = true;
      "**/.DS_Store" = true;
      "**/*.pyc" = {
        "when" = "$(basename).py";
      };
      "**/__pycache__" = true;
      "**/.idea" = true;
      "**/.directory" = true;
      "**/.classpath" = true;
      "**/.project" = true;
      "**/.settings" = true;
      "**/.factorypath" = true;
    };
    "files.associations" = {
      "**/*.html" = "html";
      "**/templates/**/*.html" = "django-html";
      "**/templates/**/*" = "django-txt";
      "**/requirements{/**;*}.{txt;in}" = "pip-requirements";
    };


    ############
    ## Python ##
    ############
    "python.linting.enabled" = true;
    "python.linting.pylintEnabled" = false;
    "python.linting.flake8Enabled" = true;
    "python.linting.flake8Path" = "/usr/bin/flake8";
    "python.linting.flake8Args" = [
      "--max-line-length=120"
      "--per-file-ignores=__init__.py=F401"  # disable __init__ unused imports
    ];

    "python.defaultInterpreterPath" = "${pkgs.python310Full}/bin/python";
    "python.languageServer" = "Pylance";
    "python.sortImports.args" = [ "-l" "120" ];
    "python.analysis.typeCheckingMode" = "basic";

    "autoDocstring.startOnNewLine" = true;
    "jupyter.askForKernelRestart" = false;
    "workbench.editorAssociations" = {
      "*.ipynb" = "jupyter-notebook";
    };

    # Purple self and cls
    "editor.tokenColorCustomizations" = {
      "textMateRules" = [
        {
          "scope" = [
            "variable.language.special.self.python"
            "variable.parameter.function.language.special.self.python"
            "variable.language.special.cls.python"
            "variable.parameter.function.language.special.cls.python"
          ];
          "settings" = {
            "foreground" = "#d54aff";
          };
        }
      ];
    };


    ##########
    ## Java ##
    ##########
    "java.configuration.runtimes" = [
      {
        "name" = "JavaSE-17";
        "path" = "${pkgs.openjdk17}";
        "default" = true;
      }
      {
        "name" = "JavaSE-11";
        "path" = "${pkgs.openjdk11}";
        "default" = false;
      }
      {
        "name" = "JavaSE-1.8";
        "path" = "${pkgs.openjdk8}";
        "default" = false;
      }
    ];


    ####################
    ## C# / Omnisharp ##
    ####################
    "omnisharp.useGlobalMono" = "always";
    "omnisharp.enableRoslynAnalyzers" = true;
    "omnisharp.enableAsyncCompletion" = true;  # Experimental; possibly disable this later.


    #########
    ## Nim ##
    #########
    "nim.nimprettyMaxLineLen" = 120;
    "[nim]" = {
      "editor.tabSize" = 2;
    };


    #########
    ## Nix ##
    #########
    "[nix]" = {
      "editor.tabSize" = 2;
    };


    #########
    ## Vim ##
    #########
    "vim.useSystemClipboard" = true;
    "vim.statusBarColorControl" = true;

    "vim.statusBarColors.normal" = ["#9876aa" "#323232"];
    "vim.statusBarColors.insert" = ["#629755" "#323232"];
    "vim.statusBarColors.visual" = ["#ffc66d" "#323232"];
    "vim.statusBarColors.visualline" = ["#ffc66d" "#323232"];
    "vim.statusBarColors.visualblock" = ["#ffc66d" "#323232"];
    "vim.statusBarColors.replace" = ["#ff6b68" "#323232"];
    "workbench.colorCustomizations" = {
        # "statusBar.background" = "#9876aa";
        # "statusBar.noFolderBackground" = "#9876aa";
        # "statusBar.debuggingBackground" = "#9876aa";
        # "statusBar.foreground" = "#323232";
        # "statusBar.debuggingForeground" = "#323232";

        # Added by Blockman plugin
        "editor.lineHighlightBackground" = "#1073cf2d";
        "editor.lineHighlightBorder" = "#9fced11f";
    };


    #########
    ## Git ##
    #########
    "git.autofetch" = true;
    "git.enableSmartCommit" = true;
    "git.enableCommitSigning" = true;

    "diffEditor.ignoreTrimWhitespace" = false;

    "redhat.telemetry.enabled" = true;
    "window.zoomLevel" = -0.25;
}