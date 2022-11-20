# Gitopia Repo Oluşturma

![Repo](https://user-images.githubusercontent.com/107190154/202877083-63430403-19a2-462c-a472-3960a6365ee2.png)

## Buradan [Gitopia](https://gitopia.com/login) sitesine gidelim.

<img width="1246" alt="yeni1" src="https://user-images.githubusercontent.com/107190154/202879901-088d2cc9-a263-4dae-9741-866383238f7d.png">

## Create a Repository kısmından bir repo oluşturalım.

<img width="1258" alt="23431" src="https://user-images.githubusercontent.com/107190154/202926034-5fd59536-44fa-470d-9b82-e5d2dfad0401.png">

## Sunucumuza girelim ve şu komutları yazalım.

### Git Remote Kurulumu

```
curl https://get.gitopia.com | bash
```

### Bir klasör oluşturalım ve ardından diğer komutları girelim.

```
mkdir repo-adı
```

```
cd repo-adı
```

```
git config --global user.name "İsminiz"
```
```
git config --global user.email "mailiniz"
```

## İlgili kısımları düzenleyin.

```
echo "# repo-adı" >> README.md
git init
git add README.md
git commit -m "açıklama"
```

## Sağ taraftan Download Wallet butonuna basalım. .json uzantılı dosya indirecek.

<img width="200" alt="yeni4" src="https://user-images.githubusercontent.com/107190154/202880072-a0fe6a7a-c318-47ce-92ad-57ec093cfa80.png">

## Kurulum adında bir klasör oluşturmuştum. Şimdi o klasöre gireceğiz ve az evvel indirdiğimiz .json uzantılı dosyayı içine atacağız.

<img width="734" alt="313w1" src="https://user-images.githubusercontent.com/107190154/202926386-f134a04a-8103-4b6e-ae4b-ed056447b42a.png">

## İndirdiğimiz .json uzantılı dosya şu şekilde klasöre taşıyalım.

<img width="733" alt="567ujm" src="https://user-images.githubusercontent.com/107190154/202926389-0df142bf-bd0f-418b-89f8-20422c159920.png">

## Sunucumuza şu komutu yazalım.

```
export GITOPIA_WALLET=/root/klasör-adı/cüzdanadınız.json
```

**Örneğin:**

```
export GITOPIA_WALLET=/root/Kurulum/BlackOwl-TR.json
```

## Şimdi ise şuradaki komutları girelim.

```
git remote add origin gitopia://BlackOwlTR/Kurulum
git push -u origin master
```

## Readme.md dosyamız oluşmuş olacak. Bu dosyanın içine girip içine gerekli dokümanları ekleyip kaydedelim.

## Şu komutlarla repomuzu güncelleyelim.
```
echo "# repo-adı" >> README.md
git init
git add README.md
git commit -m "açıklama"
```

```
git remote add origin gitopia://BlackOwlTR/Kurulum
git push -u origin master
```

### Hepinize Kolay Gelsin.

