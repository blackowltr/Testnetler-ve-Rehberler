# Gitopia Taşıma İşlemi (Gitopia Migration Process)

![workout](https://user-images.githubusercontent.com/107190154/202605593-aad830fc-3dfa-4243-9951-540ab89500ff.png)

### Öncelikle halihazırda gitopia kurulu olan sunucumuza bağlanacağız ve bize lazım olan dosyaları yedekleyeceğiz. 
### First of all, we will connect to our server that already has gitopia installed and back up the files we need.

### Winscp veya benzer bir programla sunumuza bağlanalım.
### Let's connect to our presentation with Winscp or a similar program.

![image](https://user-images.githubusercontent.com/107190154/202599151-39f97d17-da7f-41f6-99aa-839dab659206.png)

### .gitopia adlı klasör siz de görünmüyorsa ctrl + alt + h ile görünür hale getirebilirsiniz.

### If the .gitopia folder is not visible to you either, you can make it visible with ctrl + alt + H.

### Şimdi .gitopia adlı klasöre girelim. Ardından config adlı klasörün içine girelim. 

### Now let's go into the folder called .gitopia. Then let's go inside the folder called config.

### Yedeklememiz gereken dosya aşağıdaki görselde işaretlediğim, priv.validator.key.json dosyasıdır. Bunu kendi bilgisayarımıza yedekleyelim.

### The file that we need to back up is the `priv.validator.key.json` file that I marked in the image below. Let's back this up to our own computer.

<img width="591" alt="capture_20221118050438460" src="https://user-images.githubusercontent.com/107190154/202600311-5f274bd6-bb0f-4aba-85e8-1b4af5e07232.png">

### Ardından çalışan düğümümüzü durdurmamız gerekiyor. Bu kısım çok önemli. Durdurmadan taşıma işlemi yaparsanız ağdan atılırsınız.

### Then we need to stop our running node. This part is very important.  If you move without stopping, you will be thrown out of the network.

### Şu komutla durduralım:

### Let's stop with this command:

```
sudo systemctl stop gitopiad
```

### Şimdi yeni yani taşıma yapmak istediğimiz sunucumuza Gitopia node kuralım ve onun senkronize olmasını bekleyelim.

### Now let's set up a Gitopia node on our new server, which we want to move to, and wait for it to synchronize.

### Senkronizasyon işlemi devam ederken biz eski cüzdanımızı kurtaralım. 

### While the synchronization process is in progress, let's recover our old wallet.

### Cüzdan Kurtarma Komutu

### Wallet Recovery Command

```
gitopiad keys add walletname --recover
```

### Senkronizasyon çıktımız false olduğunda eski sunucumuzdan yedeklediğimiz priv.validator.key.json dosyasını yeni sunucuda .gitopia/config altına atalım.

### When our synchronization output is false, we back up the `priv.validator.key.json` file from our old server on the new server let's throw it under .gitopia/config.

### Senkronizasyon Kontrol Komutu

### Synchronization Control Command

```
gitopiad status 2>&1 | jq .SyncInfo
```

<img width="588" alt="capture_20221118052657024" src="https://user-images.githubusercontent.com/107190154/202602844-f2c318ee-1c29-40ce-89f9-12f7cbb51803.png">

### Her şey bu kadardı, okuduğunuz için teşekkürler. Forklamayı ve yıldızlamayı unutmayın. Herhangi bir sorun ya da problem olursa bana discord üzerinden ulaşabilirsiniz. (blackowl#7099)

### That was it, thanks for reading. Don't forget to fork and star. If there are any problems or problems, you can contact me via discord. (blackowl#7099)

# [Gitopia Türkiye](https://t.me/GitopiaTR)
# [Notitia Sohbet Kanalı] (https://t.me/NotitiaGroup)
# [Notitia Duyuru Kanalı] (https://t.me/NotitiaChannel)
