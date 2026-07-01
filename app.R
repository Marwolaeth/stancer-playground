# Launch the ShinyApp (Do not remove this comment)
# To deploy, run: rsconnect::deployApp()
# Or use the blue button on top of this file

remotes::install_github("Marwolaeth/stancer-playground")
usethis::use_git_ignore("rsconnect/")
pkgload::load_all(export_all = FALSE, helpers = FALSE, attach_testthat = FALSE)
options("golem.app.prod" = TRUE)
stancer.playground::run_app() # add parameters here (if any)
