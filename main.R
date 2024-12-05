# install.packages("reticulate")

library(reticulate)
use_virtualenv("./miprovenv")
py_run_file("python.py")

# install.packages("qmethod")
library(qmethod)

podatci <- read.csv("./data/answers.csv")

demografski <- podatci[1:6]
vlasnistvo <- podatci[7:11]
privatnost <- podatci[12:16]
transparentnost <- podatci[17:21]
analitika <- podatci[22:26]
koristenje <- podatci[27:31]

prep <- function(l) {
  names(l) <- sprintf("st_%d", seq(1, length(names(l))))
  l <- t(l)
  colnames(l) <- sprintf("par_%d", seq(1, dim(l)[2]))
  l <- list(l)
  l <- l[[1]]
  return(l)
}

vlasnistvo <- prep(vlasnistvo)
privatnost <- prep(privatnost)
transparentnost <- prep(transparentnost)
analitika <- prep(analitika)
koristenje <-prep(koristenje)

vlasnistvo

r1 <- qmethod(vlasnistvo, 2)
r2 <- qmethod(privatnost, 2)
r3 <- qmethod(transparentnost, 2)
r4 <- qmethod(analitika, 2)
r5 <- qmethod(koristenje, 2)

summary(r1)
summary(r2)
summary(r3)
summary(r4)
summary(r5)

all_sorts <- podatci[7:length(podatci)]
all_sorts <- prep(all_sorts)

r_full <- qmethod(all_sorts, 5)
summary(r_full)
