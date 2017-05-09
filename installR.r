
install.packages('curl', repos='http://cran.us.r-project.org')
install.packages('httr',repos='http://cran.us.r-project.org')
install.packages('git2r',repos='http://cran.us.r-project.org')
install.packages(c('repr', 'IRdisplay', 'evaluate', 'crayon', 'pbdZMQ', 'devtools', 'uuid', 'digest'),repos='http://cran.us.r-project.org')
devtools::install_github('IRkernel/IRkernel')
IRkernel::installspec(user = FALSE)

