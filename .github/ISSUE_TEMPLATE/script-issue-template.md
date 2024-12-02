name: Script Not Working
about: Use this template if a script isn't working as expected.

title: "[Script Issue] - <Brief description of the problem>"
labels: bug, script-issue
assignees: ''

body:
  - type: markdown
    attributes:
      value: |
        ## Description
        Please provide a detailed description of the issue you're facing with the script.

  - type: input
    attributes:
      label: "Which script are you having issues with?"
      description: "Provide the name or description of the script causing the issue."
      placeholder: "e.g., cleanup.sh, data-migration.ps1"
      required: true

  - type: input
    attributes:
      label: "What behavior were you expecting?"
      description: "Explain what you expected the script to do."
      placeholder: "e.g., I expected the script to delete temp files"
      required: true

  - type: textarea
    attributes:
      label: "What did you observe instead?"
      description: "Explain what actually happened when you ran the script."
      placeholder: "e.g., The script returned an error saying 'File not found'."
      required: true

  - type: input
    attributes:
      label: "What operating system and version are you using?"
      description: "Please include the operating system (e.g., Windows 10, Ubuntu 20.04) and version."
      required: true

  - type: input
    attributes:
      label: "What version of the script are you using?"
      description: "If possible, include the version number or commit hash of the script that caused the issue."
      required: false

  - type: textarea
    attributes:
      label: "Any error messages or logs?"
      description: "Include any error messages, output logs, or terminal output that may help in diagnosing the issue."
      placeholder: "e.g., Error: 'Permission denied'"
      required: false

  - type: input
    attributes:
      label: "Have you made any modifications to t
