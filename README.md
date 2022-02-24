# create-report

A Github action for creating generic run report (using Markdown!)

```yml
- uses:  michaelhenry/create-report@v1.1.0
  with:
    report-title: "Sample report"
    report-summary: "# HELLO WORLD \n > Your markdown text"
```

or with a markdown file

```yml
- uses:  michaelhenry/create-report@v1.1.0
  with:
    report-title: "Sample report"
    report-summary: "sample.md"
    report-summary-data-type: "file"
    report-summary-data-format: "markdown"
```

or with an html file

```yml
- uses:  michaelhenry/create-report@v1.1.0
  with:
    report-title: "Sample report"
    report-summary: "sample.html"
    report-summary-data-type: "file"
    report-summary-data-format: "html"
```

<img width="1076" alt="Screen Shot 2021-12-13 at 4 06 32" src="https://user-images.githubusercontent.com/717992/145722614-bc2987a6-72b3-4f26-9948-6bcf40658854.png">

[Sample workflow with a markdownfile](https://github.com/michaelhenry/create-report/actions/runs/1893728587true)
