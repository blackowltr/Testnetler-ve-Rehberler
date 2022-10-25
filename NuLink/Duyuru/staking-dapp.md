# Genel Bakış
**Nulink Staking Dapp, staker / worker hesabını yönetmek için kullanılan bir platformdur. Kullanıcılar, Metamask cüzdanı aracılığıyla staking hesabına giriş yapabilir, NLK (test) yapabilir ve ödülü almak için worker hesabını bağlayabilir. Bu bağlantı üzerinden Nulink Staking Dapp'a erişebilirsiniz. 
horus ağı için NuLink Staking Uygulamasını kullanmak için, kullanıcının NLK (test) ve bnb (test) başlangıç fonunu alması gerekir.**

### Çalışma Şeması

![1](https://user-images.githubusercontent.com/107190154/197859768-a9fe20d6-32d7-41d7-a283-46819939cda1.png)

**Adım 1: Cüzdanı bağlayın ve staking hesabına giriş yapın.
NuLink şu anda sadece Metamask cüzdanını destekliyor. Kullanıcıların Metamask cüzdanını önceden indirip yüklemeleri gerekir. Metamask kullanımıyla ilgili daha fazla yardıma ihtiyacınız varsa, lütfen buraya bakın. Lütfen kurulumdan sonra Metamask'ta staking yapmak için bir hesap oluşturun.**

<img width="1798" alt="2" src="https://user-images.githubusercontent.com/107190154/197859948-820b1738-bc76-4c59-901a-3d8ae1d20281.png">

**Metamask cüzdanına bağlandıktan sonra, sistem Horus ağına bağlanıp bağlanmadığınızı otomatik olarak algılar. Değilse, otomatik olarak doğru ağa geçmeniz için bir pencere açar.**

<img width="1798" alt="3" src="https://user-images.githubusercontent.com/107190154/197860154-0a226639-0cd5-4916-9b24-be90cfcbef35.png">

Not: BSC testnet için varsayılan RPC sunucusu bazen kararsız çalışmaktadır. Geçerli sunucunun çalışmadığını fark ederseniz, lütfen burada etkin olanı bulun ve Metamask ağ ayarlarından değiştirin. Metamask'ta RPC sunucusunu düzenleme konusunda yardıma mı ihtiyacınız var?**
Adım 2- NLK test tokenlerini stake pool'a yatırın.
Metamask cüzdan ile giriş yaptıktan sonra, lütfen bakiyeyi kontrol edin ve jetonları staking poola eklemek için "Staking" düğmesine tıklayın. İlk fon olarak staking hesabında yeterli NLK test token ve BNB test tokeni bulunmalıdır. Aktif bir worker'ı stake işlemini gerçekleştirdikten sonra bağlamayı unutmayın, aksi takdirde ödül verilmeyecektir.

Adım 3- Ödül kazanmak için aktif bir worker'ı bağlayın.
"Bond Worker"a tıklamadan önce aktif bir Worker node'una ihtiyaç vardır. Bir worker'ı çalıştırmak için lütfen buraya bakın. "Bond Worker"a tıkladığınızda Bond Worker sayfası açılır. Worker Adresini ve Node URL'sini girmeniz ve ardından bağlamayı onaylamanız yeterlidir. Şimdi tüm stake süreci tamamlandı ve ödül olarak NLK test token verilecek.

Adım 4- Stake'i bırak ve ayrıl.
Stake'i durdurmak ve ödülle birlikte tüm fonları almak için aşağıdaki kontrol listesini takip edin:
Unbound worker işlemi ve worker node'unu kapatma.
Fonunuzu staking pooldan çıkarın.
Ödülleri talep et.
Worker Node'umu nasıl bağlayabilirim ve Worker Node'umu nasıl kapatabilirim?
"Unbound Worker"a tıklayın. Unbound işlemini onaylamak için bir pencere açılacaktır.
Açıklama: Horus ağı için bir bond süresi 24 saattir. Bu da kullanıcının Worker'ı bağladıktan sonraki 24 saat içinde unbound yapamayacağı anlamına gelir.

Unbound işleminden sonra Worker node'u kapanmakta serbesttir.
Unstake Nasıl Yapılır?
Kaldırılıp kaldırılmayacağını sormak için "Unstake" açılır penceresine tıklayın. Staking'i onayladıktan sonra serbest bırakılacaktır.

Ödülünüzü nasıl geri çekebilirsiniz?
Unstake yaptıktan sonra ödülü geri çekmek için "Claim" butonuna tıklayın.

Transaction (İşlem) Bildirimi
Yukarıdaki tüm işlemler için Dapp, BSC testnet'te karşılık gelen bir işlem gönderir. Bildirim listesini görüntülemek için sağ üst köşedeki zile tıklayın. Her işlemin ayrıntılarını görmek için 'View details'e tıklayın.
