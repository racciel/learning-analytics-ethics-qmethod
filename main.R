# install.packages("reticulate")

library(reticulate)
use_virtualenv("./miprovenv")
py_run_file("python.py")

# install.packages("qmethod")
library(qmethod)

podatci <- read.csv("./data/answers.csv")

podatci[6][podatci[6] == "informacijske znanosti"] <- "Društvene znanosti"

demografski <- podatci[2:6]
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

r_full_2fact <- qmethod(all_sorts, 2)
r_full_3fact <- qmethod(all_sorts, 3)
r_full_4fact <- qmethod(all_sorts, 4)
summary(r_full_2fact)
summary(r_full_3fact)
summary(r_full_4fact)

loa.and.flags(r1)
loa.and.flags(r2)
loa.and.flags(r3)
loa.and.flags(r4)
loa.and.flags(r5)

loa.and.flags(r_full)

summary(r_full_2fact)
summary(r_full_3fact)
summary(r_full_4fact)

#summary(qmethod(all_sorts, extraction = 'centroid', nfactors=3, cor.method = 'kendall'))

prosjeci <- rowMeans(all_sorts)
sume <- rowSums(all_sorts)

hist(sume, breaks=5)

#install.packages("ggplot2")

library("ggplot2")
#install.packages("rlang")
ggplot(demografski, aes(x = Starost..u.godinama.)) +
  geom_bar(fill = "purple") +
  geom_text(stat = "count", aes(label = ..count..),vjust=-1, hjust = 0.3, size = 3) + 
  labs(title = "Distribucija ispitanika prema godinama", x = "Dobni razredi", y = "Broj ispitanika") +
  theme_minimal()

spolni_identitet <- demografski$Spolni.identitet
spolni_identitet[spolni_identitet != "Muško" & spolni_identitet != "Žensko" & spolni_identitet != "Ne želim se izjasniti"] <- "Ostalo"

ggplot(demografski, aes(x = "", fill = spolni_identitet)) +
  geom_bar(width = 1, stat = "count") +
  coord_polar(theta = "y") +
  labs(title = "Distribucija prema spolnom identitetu", fill = "Spol") +
  theme_minimal()

ggplot(demografski, aes(x = fct_rev(fct_infreq(Razina.studija..trenutna..)))) +
  geom_bar(fill = "orange") +
  geom_text(stat = "count", aes(label = ..count..), hjust = -0.2, size = 3) +  # Dodaj brojke
  labs(title = "Distribucija prema razini studiranja", x = "Razina studiranja", y = "Broj ispitanika") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  theme_minimal() +
  coord_flip()

#install.packages("tidyverse")
library(tidyverse)

sveuciliste_long <- demografski %>%
  separate_rows(Na.kojim.ste.sve.sveučilištima.veleučilištima.studirali., sep = ", ")
sveucilista <- sveuciliste_long$Na.kojim.ste.sve.sveučilištima.veleučilištima.studirali.

sveucilista[!sveucilista %in% c("Sveučilište u Zagrebu", "Sveučilište u Rijeci", "Sveučilište Sjever", "Sveučilište Jurja Dobrile u Puli", "Sveučilište Josipa Jurja Strossmayera u Osijeku", "Libertas međunarodno sveučilište")] <- "Ostalo"

podrucje_studiranja_long <- demografski %>%
  separate_rows(Područje.područja.studiranja., sep = ", ")
podrucja <- podrucje_studiranja_long$Područje.područja.studiranja.

ggplot(, aes(x = fct_rev(fct_infreq(sveucilista)))) +  # Sortiranje prema učestalosti
  geom_bar(fill = "green") +
  geom_text(stat = "count", aes(label = ..count..), hjust = -0.2, size = 3) +  # Dodaj brojke
  labs(title = "Distribucija prema sveučilištu", x = "Sveučilište", y = "Broj ispitanika") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  theme_minimal() +
  coord_flip()




ggplot(, aes(x = fct_rev(fct_infreq(podrucja)))) +  # Sortiranje prema učestalosti
  geom_bar(fill = "purple") +
  geom_text(stat = "count", aes(label = ..count..), hjust = -0.2, size = 3) +  # Dodaj brojke
  labs(title = "Distribucija prema području studiranja", x = "Područje studiranja", y = "Broj ispitanika") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  theme_minimal() +
  coord_flip()


rank(rowMeans(vlasnistvo))
rank(rowMeans(privatnost))
rank(rowMeans(transparentnost))
rank(rowMeans(analitika))
rank(rowMeans(koristenje))


?qmethod

data(lipset)
results <- qmethod(lipset[[1]], nfactors = 3, rotation = "varimax")
summary(results)
results

