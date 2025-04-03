UB CSE EL/R (Research - Section B) website repository
======================================================

This repo contains all the project information for current and past projects
in UB CSE EL/R program (Research - Section B).

## Request write access

Please email Zhuoyue zzhao35 [at] buffalo [dot] edu for write access.

## To add/edit a project.

Project descriptions are located under `contents/prjs/<semester>`. For Spring
20xx, the `<semester>` is `spxx`. For Fall 20xx, the `<semester>` is `faxx`.

To add a project in a semester, please make a copy of prj-template.txt in the
semester's directory and rename it as `<three-digit-ID>-<any-mnemonics>.txt`.
See the existing files as a reference. Any additional resources such as images
should be placed under `contents/imgs`.
should be put under `contents/imgs` or `contents/files`.

## To preview changes locally.

Run `make`, and you will see a local build of the website under `out`. Open
`out/index.html` and `out/prj_xxxx.html` to preview the updates locally.

## Update website.

Please build and preview locally before commit your changes to `main`.  We pull
the repo every 5 minutes on CSE server and automatically update the website by
running `make`.

## Extra dependencies
    
    pip install markdown
    pip install --user markdown3-newtab

