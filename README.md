
<!-- README.md is generated from README.Rmd. Please edit that file -->

# `{stancer-playground}`

<!-- badges: start -->

<!-- badges: end -->

## Installation

You can install the development version of `{stancer-playground}` like
so:

``` r
# FILL THIS IN! HOW CAN PEOPLE INSTALL YOUR DEV PACKAGE?
```

## Run

You can launch the application by running:

``` r
stancer.playground::run_app()
```

## About

You are reading the doc about version : 0.0.0.9000

This README has been compiled on the

``` r
Sys.time()
#> [1] "2026-05-08 16:53:38 MSK"
```

Here are the tests results and package coverage:

``` r
devtools::check(quiet = TRUE)
#> ℹ Loading stancer.playground
#> Warning: replacing previous import 'shinydashboard::taskItem' by
#> 'shinydashboardPlus::taskItem' when loading 'stancer.playground'
#> Warning: replacing previous import 'shinydashboard::dashboardHeader' by
#> 'shinydashboardPlus::dashboardHeader' when loading 'stancer.playground'
#> Warning: replacing previous import 'shinydashboard::box' by
#> 'shinydashboardPlus::box' when loading 'stancer.playground'
#> Warning: replacing previous import 'shinydashboard::messageItem' by
#> 'shinydashboardPlus::messageItem' when loading 'stancer.playground'
#> Warning: replacing previous import 'shinydashboard::dashboardSidebar' by
#> 'shinydashboardPlus::dashboardSidebar' when loading 'stancer.playground'
#> Warning: replacing previous import 'shinydashboard::dashboardPage' by
#> 'shinydashboardPlus::dashboardPage' when loading 'stancer.playground'
#> Warning: replacing previous import 'shinydashboard::notificationItem' by
#> 'shinydashboardPlus::notificationItem' when loading 'stancer.playground'
#> ── R CMD check results ────────────────────── stancer.playground 0.0.0.9000 ────
#> Duration: 1m 28s
#> 
#> ❯ checking tests ...
#>   See below...
#> 
#> ❯ checking whether package 'stancer.playground' can be installed ... WARNING
#>   See below...
#> 
#> ❯ checking code files for non-ASCII characters ... WARNING
#>   Found the following file with non-ASCII characters:
#>     R/mod_settings.R
#>   Portable packages must use only ASCII characters in their R code and
#>   NAMESPACE directives, except perhaps in comments.
#>   Use \uxxxx escapes for other characters.
#>   Function 'tools::showNonASCIIfile' can help in finding non-ASCII
#>   characters in files.
#> 
#> ❯ checking Rd \usage sections ... WARNING
#>   Undocumented arguments in Rd file 'mod_batch_analysis_server.Rd'
#>     'id' 'settings_rx'
#>   
#>   Undocumented arguments in Rd file 'mod_batch_analysis_ui.Rd'
#>     'id'
#>   
#>   Undocumented arguments in Rd file 'mod_model_config_server.Rd'
#>     'id' 'i18n'
#>   
#>   Undocumented arguments in Rd file 'mod_model_config_ui.Rd'
#>     'id' 'i18n'
#>   
#>   Undocumented arguments in Rd file 'mod_settings_server.Rd'
#>     'id'
#>   
#>   Undocumented arguments in Rd file 'mod_settings_ui.Rd'
#>     'id'
#>   
#>   Undocumented arguments in Rd file 'mod_single_analysis_server.Rd'
#>     'id' 'settings_rx'
#>   
#>   Undocumented arguments in Rd file 'mod_single_analysis_ui.Rd'
#>     'id'
#>   
#>   Functions with \usage entries need to have the appropriate \alias
#>   entries, and all their arguments documented.
#>   The \usage entries must correspond to syntactically valid R code.
#>   See chapter 'Writing R documentation files' in the 'Writing R
#>   Extensions' manual.
#> 
#> ❯ checking R code for possible problems ... NOTE
#>   mod_batch_analysis_server : <anonymous>: no visible global function
#>     definition for 'head'
#>   mod_model_config_server : <anonymous>: no visible global function
#>     definition for 'updatePasswordInput'
#>   Undefined global functions or variables:
#>     head updatePasswordInput
#>   Consider adding
#>     importFrom("utils", "head")
#>   to your NAMESPACE file.
#> 
#> ── Test failures ───────────────────────────────────────────────── testthat ────
#> 
#> > # This file is part of the standard setup for testthat.
#> > # It is recommended that you do not modify it.
#> > #
#> > # Where should you do additional test configuration?
#> > # Learn more about the roles of various files in:
#> > # * https://r-pkgs.org/testing-design.html#sec-tests-files-overview
#> > # * https://testthat.r-lib.org/articles/special-files.html
#> > 
#> > library(testthat)
#> > library(stancer.playground)
#> Warning messages:
#> 1: replacing previous import 'shinydashboard::taskItem' by 'shinydashboardPlus::taskItem' when loading 'stancer.playground' 
#> 2: replacing previous import 'shinydashboard::dashboardHeader' by 'shinydashboardPlus::dashboardHeader' when loading 'stancer.playground' 
#> 3: replacing previous import 'shinydashboard::box' by 'shinydashboardPlus::box' when loading 'stancer.playground' 
#> 4: replacing previous import 'shinydashboard::messageItem' by 'shinydashboardPlus::messageItem' when loading 'stancer.playground' 
#> 5: replacing previous import 'shinydashboard::dashboardSidebar' by 'shinydashboardPlus::dashboardSidebar' when loading 'stancer.playground' 
#> 6: replacing previous import 'shinydashboard::dashboardPage' by 'shinydashboardPlus::dashboardPage' when loading 'stancer.playground' 
#> 7: replacing previous import 'shinydashboard::notificationItem' by 'shinydashboardPlus::notificationItem' when loading 'stancer.playground' 
#> > 
#> > test_check("stancer.playground")
#> Saving _problems/test-golem-recommended-2.R
#> Loading required package: shiny
#>   110: stop
#>   109: .root_session
#>   108: get_cookie
#>   107: eval_tidy
#>   106: eventFunc
#>    93: observeEvent(get_cookie("stancer_api_key"))
#>    92: contextFunc
#>    91: env$runWith
#>    78: ctx$run
#>    77: run
#>    58: flushCallback
#>    57: FUN
#>    56: lapply
#>    55: ctx$executeFlushCallbacks
#>    54: .getReactiveEnvironment()$flush
#>    53: shiny:::flushReact
#>    52: private$flush
#>    51: session$setInputs
#>    50: rlang::eval_tidy [test-golem-recommended.R#58]
#>    24: testServer
#>    23: eval [test-golem-recommended.R#54]
#>    22: eval
#>    13: test_code
#>    12: source_file
#>    11: FUN
#>    10: lapply
#>     4: test_files_serial
#>     3: test_files
#>     2: test_dir
#>     1: test_check
#> [ FAIL 1 | WARN 1 | SKIP 1 | PASS 8 ]
#> 
#> ══ Skipped tests (1) ═══════════════════════════════════════════════════════════
#> • rlang_is_interactive() is not TRUE (1): 'test-golem-recommended.R:71:2'
#> 
#> ══ Warnings ════════════════════════════════════════════════════════════════════
#> ── Warning ('test-golem-recommended.R:58:3'): (code run outside of `test_that()`) ──
#> Error in .root_session: Root session not found.
#> Backtrace:
#>      ▆
#>   1. ├─shiny::testServer(...) at test-golem-recommended.R:54:1
#>   2. │ ├─shiny:::withMockContext(...)
#>   3. │ │ ├─shiny::isolate(...)
#>   4. │ │ │ ├─shiny::..stacktraceoff..(...)
#>   5. │ │ │ └─ctx$run(...)
#>   6. │ │ │   ├─promises::with_promise_domain(...)
#>   7. │ │ │   │ └─domain$wrapSync(expr)
#>   8. │ │ │   ├─shiny::withReactiveDomain(...)
#>   9. │ │ │   │ └─promises::with_promise_domain(...)
#>  10. │ │ │   │   └─domain$wrapSync(expr)
#>  11. │ │ │   │     └─base::force(expr)
#>  12. │ │ │   ├─shiny:::with_otel_span_context(...)
#>  13. │ │ │   │ └─base::force(expr)
#>  14. │ │ │   ├─shiny::captureStackTraces(...)
#>  15. │ │ │   │ └─promises::with_promise_domain(...)
#>  16. │ │ │   │   └─domain$wrapSync(expr)
#>  17. │ │ │   │     └─base::withCallingHandlers(expr, error = doCaptureStack)
#>  18. │ │ │   └─env$runWith(self, func)
#>  19. │ │ │     └─shiny (local) contextFunc()
#>  20. │ │ │       └─shiny::..stacktraceon..(expr)
#>  21. │ │ ├─shiny::withReactiveDomain(...)
#>  22. │ │ │ └─promises::with_promise_domain(...)
#>  23. │ │ │   └─domain$wrapSync(expr)
#>  24. │ │ │     └─base::force(expr)
#>  25. │ │ └─withr::with_options(...)
#>  26. │ │   └─base::force(code)
#>  27. │ └─rlang::eval_tidy(quosure, mask, rlang::caller_env())
#>  28. └─session$setInputs(x = 2) at test-golem-recommended.R:58:17
#>  29.   └─private$flush()
#>  30.     └─shiny:::flushReact()
#>  31.       └─.getReactiveEnvironment()$flush()
#>  32.         └─ctx$executeFlushCallbacks()
#>  33.           └─base::lapply(...)
#>  34.             └─shiny (local) FUN(X[[i]], ...)
#>  35.               └─shiny (local) flushCallback()
#>  36.                 └─shiny:::hybrid_chain(...)
#>  37.                   └─shiny (local) do()
#>  38.                     └─base::tryCatch(...)
#>  39.                       └─base (local) tryCatchList(expr, classes, parentenv, handlers)
#>  40.                         └─base (local) tryCatchOne(expr, names, parentenv, handlers[[1L]])
#>  41.                           └─value[[3L]](cond)
#>  42.                             └─shiny (local) catch(e)
#>  43.                               └─shiny::printError(e)
#> 
#> ══ Failed tests ════════════════════════════════════════════════════════════════
#> ── Error ('test-golem-recommended.R:2:2'): app ui ──────────────────────────────
#> <evalError/missingArgError/error/condition>
#> Error in `mod_model_config_ui("model_config_1")`: argument "i18n" is missing, with no default
#> Backtrace:
#>      ▆
#>   1. └─stancer.playground:::app_ui() at test-golem-recommended.R:2:9
#>   2.   ├─cookies::add_cookie_handlers(...)
#>   3.   ├─shinydashboardPlus::dashboardPage(...)
#>   4.   ├─shinydashboardPlus::dashboardControlbar(...)
#>   5.   └─stancer.playground:::mod_model_config_ui("model_config_1")
#>   6.     ├─htmltools::tagList(...)
#>   7.     │ └─rlang::dots_list(...)
#>   8.     ├─htmltools::div(...)
#>   9.     │ └─rlang::dots_list(...)
#>  10.     └─htmltools::h4(i18n$t("LLM Provider"))
#>  11.       └─rlang::dots_list(...)
#> 
#> [ FAIL 1 | WARN 1 | SKIP 1 | PASS 8 ]
#> Error:
#> ! Test failures.
#> Execution halted
#> 
#> 1 error ✖ | 3 warnings ✖ | 1 note ✖
#> Error:
#> ! R CMD check found ERRORs
```

``` r
covr::package_coverage()
#> Error:
#> ! Failure in `C:/Users/apavlyuchenko/AppData/Local/Temp/RtmpMNqV6b/R_LIBS1c2031a5118e/stancer.playground/stancer.playground-tests/testthat.Rout.fail`
#> ...)
#>   3.   ├─shinydashboardPlus::dashboardPage(...)
#>   4.   ├─shinydashboardPlus::dashboardControlbar(...)
#>   5.   └─stancer.playground:::mod_model_config_ui("model_config_1")
#>   6.     ├─htmltools::tagList(...)
#>   7.     │ └─rlang::dots_list(...)
#>   8.     ├─htmltools::div(...)
#>   9.     │ └─rlang::dots_list(...)
#>  10.     └─htmltools::h4(i18n$t("LLM Provider"))
#>  11.       └─rlang::dots_list(...)
#> 
#> [ FAIL 1 | WARN 1 | SKIP 1 | PASS 8 ]
#> Error:
#> ! Test failures.
#> Execution halted
```
