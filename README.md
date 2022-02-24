# create-report

A Github action for creating generic run report (using Markdown!)

```yml
- uses:  michaelhenry/create-report@v1.0.1
  with:
    report-title: "Sample report"
    report-summary: "# HELLO WORLD \n > Your markdown text"
```

or with a markdown file

```yml
- uses:  michaelhenry/create-report@v1.0.1
  with:
    report-title: "Sample report"
    report-summary: "sample.md"
    report-summary-data-type: "file"
```

<img width="1076" alt="Screen Shot 2021-12-13 at 4 06 32" src="https://user-images.githubusercontent.com/717992/145722614-bc2987a6-72b3-4f26-9948-6bcf40658854.png">

[Sample workflow with a markdownfile](https://github.com/michaelhenry/create-report/runs/4549800696?check_suite_focus=true) generated from [.github/workflows/report.yml](https://github.com/michaelhenry/create-report/blob/main/.github/workflows/report.yml)
