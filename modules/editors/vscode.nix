{ options, config, pkgs, lib, inputs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.editors.vscode;

  extensions-input = inputs.nix-vscode-extensions.extensions.${pkgs.system};
  # Use latest extension if not found for given vscode version
  extensions = lib.attrsets.recursiveUpdate
    extensions-input
    (extensions-input.forVSCodeVersion pkgs.vscode.version);
in
{
  options.modules.editors.vscode = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    home-manager.users.huantian.programs.vscode = {
      enable = true;
      extensions = with extensions.vscode-marketplace; [
        # Random Utilities
        adpyke.codesnap
        albert.tabout
        drrouman.git-coauthors
        ibm.output-colorizer
        icrawl.discord-vscode
        louiswt.regexp-preview
        mkhl.direnv
        oderwat.indent-rainbow
        # usernamehw.errorlens
        streetsidesoftware.code-spell-checker

        # Themes
        code-bizarre.purple-wolf-theme
        monokai.theme-monokai-pro-vscode
        teabyii.ayu
        # Icon Themes
        pkief.material-icon-theme

        # Git/GitHub
        eamodio.gitlens
        github.vscode-github-actions
        github.vscode-pull-request-github
        waderyan.gitblame

        # Tests
        hbenl.vscode-test-explorer
        ms-vscode.test-adapter-converter

        # Python
        ms-python.python
        ms-python.vscode-pylance
        # Python Utils
        batisteo.vscode-django
        charliermarsh.ruff
        kevinrose.vsc-python-indent
        littlefoxteam.vscode-python-test-adapter
        njpwerner.autodocstring
        ms-python.black-formatter

        # Jupyter
        ms-toolsai.jupyter
        ms-toolsai.jupyter-keymap
        ms-toolsai.jupyter-renderers
        ms-toolsai.vscode-jupyter-cell-tags
        ms-toolsai.vscode-jupyter-slideshow

        # Java
        redhat.java
        vscjava.vscode-java-debug
        vscjava.vscode-java-dependency
        vscjava.vscode-java-test

        # C#
        ms-dotnettools.csharp
        ms-dotnettools.vscode-dotnet-runtime

        # C/C++
        ms-vscode.cmake-tools
        ms-vscode.cpptools
        ms-vscode.cpptools-extension-pack
        ms-vscode.cpptools-themes
        twxs.cmake
        vadimcn.vscode-lldb

        # Haskell
        haskell.haskell
        justusadam.language-haskell

        # HTML/CSS
        ecmel.vscode-html-css
        ms-vscode.live-server
        bradlc.vscode-tailwindcss

        # Other Lang Support
        alexcvzz.vscode-sqlite
        davidanson.vscode-markdownlint
        editorconfig.editorconfig
        jnoortheen.nix-ide
        nimsaem.nimvscode
        redhat.vscode-yaml
        tamasfe.even-better-toml
      ];


      userSettings = {
        #############
        ## General ##
        #############

        # Auto Update
        "update.mode" = "none";
        "extensions.autoUpdate" = false;

        # Terminal Setup
        "terminal.integrated.fontFamily" = "MesloLGS NF";
        "terminal.external.linuxExec" = "/home/huantian/.nix-profile/bin/zsh";
        "terminal.integrated.defaultProfile.linux" = "zsh";
        "terminal.integrated.profiles.linux" = {
          "bash" = {
            "path" = "${pkgs.bash}/bin/bash";
            "icon" = "terminal-bash";
          };
          "zsh" = {
            "path" = "/home/huantian/.nix-profile/bin/zsh";
          };
        };
        "terminal.integrated.env.linux" = {
          "PYTHONPATH" = "\${workspaceFolder}";
        };
        "terminal.integrated.persistentSessionReviveProcess" = "never";

        # Debug terminal/process
        "debug.onTaskErrors" = "abort";
        "debug.terminal.clearBeforeReusing" = true;

        # Themes
        "workbench.colorTheme" = "Default Dark Modern";
        "workbench.iconTheme" = "material-icon-theme";

        # Fonts
        "editor.fontSize" = 13;
        "editor.fontFamily" = "JetBrains Mono";
        "editor.fontLigatures" = true;

        # Other editor display
        "editor.guides.bracketPairs" = true;
        "editor.bracketPairColorization.enabled" = true;
        "editor.rulers" = [ 80 100 ];

        # Cursor and Scrolling
        "editor.cursorBlinking" = "phase";
        "editor.cursorSmoothCaretAnimation" = "on";
        "editor.smoothScrolling" = true;

        # Auto-suggest
        "editor.suggestSelection" = "first";
        "editor.inlineSuggest.enabled" = true;
        "editor.suggest.preview" = true;
        "editor.quickSuggestions" = {
          "strings" = true;
        };

        # File explorer
        "explorer.confirmDelete" = false;
        "explorer.sortOrder" = "type";

        # Auto Save
        "files.autoSave" = "afterDelay";
        "files.autoSaveDelay" = 200;

        "files.trimTrailingWhitespace" = true;

        # Files to hide from explorer
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
        # Additional file associations
        "files.associations" = {
          "**/*.html" = "html";
          "**/templates/**/*.html" = "django-html";
          "**/templates/**/*" = "django-txt";
          "**/requirements{/**;*}.{txt;in}" = "pip-requirements";
        };
        "workbench.editorAssociations" = {
          "*.ipynb" = "jupyter-notebook";
        };


        ############
        ## Python ##
        ############
        "[python]" = {
          "editor.formatOnSave" = true;
          "editor.formatOnType" = false;
          "editor.defaultFormatter" = "ms-python.black-formatter";
          "editor.codeActionsOnSave" = {
            "source.organizeImports" = true;
          };
        };

        "python.languageServer" = "Pylance";
        "python.analysis.typeCheckingMode" = "strict";

        "ruff.organizeImports" = true;
        "autoDocstring.startOnNewLine" = true;
        "jupyter.askForKernelRestart" = false;

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
        "omnisharp.enableAsyncCompletion" = true;
        "omnisharp.enableDecompilationSupport" = false;
        "omnisharp.enableEditorConfigSupport" = true;
        "omnisharp.organizeImportsOnFormat" = true;
        "omnisharp.useModernNet" = true;


        #########
        ## Nim ##
        #########
        "nim.nimprettyMaxLineLen" = 100;
        "[nim]" = {
          "editor.tabSize" = 2;
        };


        #########
        ## Nix ##
        #########
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "${pkgs.nil}/bin/nil";
        "nix.serverSettings".nil = {
          formatting.command = [ "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt" ];
          nix.flake = {
            autoArchive = true;
          };
        };
        "[nix]" = {
          "editor.tabSize" = 2;
          "editor.formatOnSave" = true;
        };


        ###########
        # Haskell #
        ###########


        #########
        ## Vim ##
        #########
        "vim.useSystemClipboard" = true;
        "vim.statusBarColorControl" = true;

        "vim.statusBarColors.normal" = [ "#9876aa" "#323232" ];
        "vim.statusBarColors.insert" = [ "#629755" "#323232" ];
        "vim.statusBarColors.visual" = [ "#ffc66d" "#323232" ];
        "vim.statusBarColors.visualline" = [ "#ffc66d" "#323232" ];
        "vim.statusBarColors.visualblock" = [ "#ffc66d" "#323232" ];
        "vim.statusBarColors.replace" = [ "#ff6b68" "#323232" ];
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
      };
    };
  };
}
