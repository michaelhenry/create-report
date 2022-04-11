# create-report

A Github action for creating generic run report (using Markdown!)

[![codecov](https://codecov.io/gh/michaelhenry/create-report/branch/main/graph/badge.svg?token=TC3XYJYG61)](https://codecov.io/gh/michaelhenry/create-report)
[![codebeat badge](https://codebeat.co/badges/f52c2068-17ca-41a1-8421-f6b54e4155d4)](https://codebeat.co/projects/github-com-michaelhenry-create-report-main)


```yml
- uses:  michaelhenry/create-report@v1.1.0
  with:
    report-title: "Sample report"
    report-summary: "# HELLO WORLD \n > Your markdown text"
```

or with a markdown file - ([sample.md](sample.md) becomes [GHAction report](https://github.com/michaelhenry/create-report/runs/5320754864?check_suite_focus=true))
```yml
- uses:  michaelhenry/create-report@v1.1.0
  with:
    report-title: "Sample report"
    report-summary: "sample.md"
    report-summary-data-type: "file"
    report-summary-data-format: "markdown"
```

or with an html file - ([sample.html](sample.html) becomes [GHAction report](https://github.com/michaelhenry/create-report/runs/5320933581?check_suite_focus=true))

```yml
- uses:  michaelhenry/create-report@v1.1.0
  with:
    report-title: "Sample report"
    report-summary: "sample.html"
    report-summary-data-type: "file"
    report-summary-data-format: "html"
```

<img width="1076" alt="Screen Shot 2021-12-13 at 4 06 32" src="https://user-images.githubusercontent.com/717992/145722614-bc2987a6-72b3-4f26-9948-6bcf40658854.png">


[Sample workflow with a markdownfile](https://github.com/michaelhenry/create-report/runs/4549800696?check_suite_focus=true) generated from [.github/workflows/report.yml](https://github.com/michaelhenry/create-report/blob/main/.github/workflows/report.yml)
