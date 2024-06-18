# Aligned ile SP1 Kanıtları Gönderin ve Doğrulayın

![image](https://github.com/blackowltr/Testnetler-ve-Rehberler/assets/107190154/9a13eba8-6eb1-4ad4-b3a5-1feecbd8b4b4)

## Aligned'ı İndir ve Kur

Testnette kanıt göndermek için aşağıdaki komutu çalıştırarak Aligned'ı indirip kurun:

```bash
curl -L https://raw.githubusercontent.com/yetanotherco/aligned_layer/main/batcher/aligned/install_aligned.sh | bash
```

Herhangi bir sorun yaşarsanız, aynı komutu çalıştırarak güncelleme yapabilirsiniz.

## Örnek SP1 Kanıt Dosyalarını İndir

Aşağıdaki komutu kullanarak örnek bir SP1 kanıt dosyası ve ELF dosyasını indirin:

```bash
curl -L https://raw.githubusercontent.com/yetanotherco/aligned_layer/main/batcher/aligned/get_proof_test_files.sh | bash
```

## Kanıtı Gönder

Aşağıdaki komutla kanıtı gönderin:

```bash
aligned submit \
  --proving_system SP1 \
  --proof ~/.aligned/test_files/sp1_fibonacci.proof \
  --vm_program ~/.aligned/test_files/sp1_fibonacci-elf \
  --aligned_verification_data_path ~/aligned_verification_data \
  --conn wss://batcher.alignedlayer.com
```

Kanıtınızın Aligned'da doğrulanması için birkaç saniye bekleyin.

## Kanıtı Zincir Üzerinde Doğrula

Kanıtınızın doğrulandığını aşağıdaki komutla kontrol edin:

```bash
aligned verify-proof-onchain \
  --aligned-verification-data ~/aligned_verification_data/*.json \
  --rpc https://ethereum-holesky-rpc.publicnode.com \
  --chain holesky
```

Hepsi bu kadar! Aligned kullanarak SP1 kanıtlarını başarıyla gönderdiniz ve doğruladınız.

[Beni X'te takip etmeyi unutmayın.](https://x.com/brsbtc)
