name: Bug Report
description: File a bug report
title: "[Bug]: "
body:
  - type: markdown
    attributes:
      value: |
        Thanks for taking the time to fill out this bug report!
  - type: checkboxes
    id: checks0
    attributes:
      label: Checks
      description: Verify that all of the following is true:
      options:
        - label: I have searched the bug with a few keywords, and I confirm this bug was not yet reported.
          required: true
        - label: The round I am reporting the bug from, or I am gonna talk about, has already ended.
          required: true
  - type: dropdown
    id: location
    attributes:
      label: Location
      multiple: true
      description: Where did the bug happen?
      options:
        - Horizon (Default)
        - Intrepid
        - Spark
        - Away Site
        - Third party ship
        - Overmap
        - Event / Other
  - type: textarea
    id: what-happened
    attributes:
      label: What did you encounter?
      description: Please detail, as objectively and specifically as possible, what happened that you considered to be a bug.
      placeholder: Remember to be specific.
    validations:
      required: true
  - type: textarea
    id: howtoreproduce
    attributes:
      label: How to reproduce
      description: Describe how to reproduce the issue or, if unable to reproduce it, what steps you did that you believe might have caused the bug.
      placeholder: Remember to specify if it's a guess or you can actually reproduce it with these steps.
  - type: textarea
    id: identificationdetails
    attributes:
      label: Additional identification details
      description: If you talked with an admin to have the bug resolved in-round, and/or have the round ID, please supply them here.
      placeholder: Round ID / Admin talked to ckey
