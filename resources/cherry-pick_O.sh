#!/bin/bash

source ./resources/reponame_array.sh

red="\033[01;31m"
green="\033[01;32m"
blue="\033[01;34m"
white="\033[01;37m"
nc="\033[0m"
bold="\033[1m"

clear
echo -e "${bold}${red}======================================================================"
echo -e "                            Cherry-pick"
echo -e "======================================================================${blue}"

cd ../ # we have sources near scripts folder

for repo_name in "${repos_array[@]}"; do
    cd $repo_name
    ################################################################
    #                                                              #
    #                    Thank's to SonyAosp ;)                    #
    #                                                              #
    ################################################################
    git remote add SonyAosp git@github.com:SonyAosp/"$repo_name".git
    git remote update
    git reset --hard
    git checkout origin/android-8.0
    cd ../
done

cd platform_build
git cherry-pick 05e2b3d2d429ea8d8db9ec672ce5d00cc3c4c440 75df905752bbcbcaf47df8c2d0de69c665fa3c5e \
                87d63743052a0ede615e73a7d0dfc4269b79d236 29eb262532657bace1199d6818f860c69ec17ef8 \
                655ab487d3c6a3d06cb7b2c95dfef6eb5a4d119c 873f665cbbb980ce99e0adab2ab6da91f0a8453c \
                477189744727968af8494eefe94a02acc0f346ba 7cc501d573bc2cf24f3f34ca73f5d589570bd26a \
                30a0c8ca273e852295e561b0876c859f0a65df80 4853c39e442dd73b394bf77d171ecb16d91e0c62 \
                8564413f73b106b92bed76c070b02e4cc1cc7389 4da7a48f117425c61c535908e664790163b5f1dc \
                f0367972b226962ca34daa69b9441609da1c2fc9 d394af02f147cfa1afaefa37b1686d6bb0aabea3

# cd ../platform_external_toybox
# git cherry-pick

cd ../platform_frameworks_av
git cherry-pick f66ecabf236c39f2920b8b3ef56e84202ff8558f 957382b23c78aca66d0be5f803328b6eb1f153b5 \
                952041d0f7b3f55bda81f95621fa72b287547a09 8e079d62b144e7ad76acfe57fa6a9101e7e41924 \
                429c71172bb8ba3e9db276e0c76de24fa2ce309f

cd ../platform_frameworks_base
git cherry-pick b3e19dfca7fdbe7bd74e9707f8af34b0715d8270 dc16ca91591067a2d82f7cad29e12fc435064e8b \
                e59381d1401ac9a87443bb1974400db6b5de01c1 c2c7c614d821aa1eca522aa4000c0bad38ed6a6f \
                9143b078b576e5fb2cb425c577417bed80a7ef32 1c5ea148329d6e22ebafe3244351de581df3e3bd \
                5d8a1156f13c72c2a8e8b95bafa5cb06f5382c9b

# cd ../platform_frameworks_native
# git cherry-pick

cd ../platform_hardware_qcom_audio
git cherry-pick 8f7dbf0c49a1022fe7aeb62b228885f161116c88 2cb600b98bdc481bc7fcab0f46102dd67c543485 \
                3c28aabef255a91284628a00ce8e8f9a359c948a f1a6a6efe07b57199796813fc335c09d8644c693 \
                bd64c8385cb495f015e04abfd7411b343438035f d058462fe6a0f69e24082790214420513345c8c7 \
                ac88ed6d78bf0d625971401d19dabc9e7c6d1d6c

# cd ../platform_hardware_qcom_bt
# git cherry-pick

cd ../platform_hardware_qcom_display
git cherry-pick 04f0cbae416fc8c6fef036a9fc83504c15426c83 241bd8eb29371091e3e8ffba7c4f3c0088f473c3 \
                9afb029a23f715030821a01b0b7f9e01da7b88c1

cd ../platform_hardware_qcom_gps
git cherry-pick b9c85f6b1b4d279c244c94f0034e7b5375409516

# cd ../platform_hardware_qcom_keymaster
# git cherry-pick

cd ../platform_hardware_qcom_media
git cherry-pick eb99e4fbcb2abf18f6aced63295ac67ec12d5a37

# cd ../platform_packages_apps_Nfc
# git cherry-pick

cd ../platform_packages_apps_Settings
git cherry-pick 213d884d74643eaef8e11818c3bd67068f472a5c 9ade4e972082fa0d935fa036afee4e1ee7e27316 \
                e41d1fd77f14987513692694d3afef87a2e13178 38109677721d7c5c9eafd9cf467b2c0e00236d0d \
                b9009111a7994381314909d0c9ff13d6a54b96f9 433eeac6da4881a71da09a6c4b4e26d3ada1fad4 \
                65fdc33250190620cf6efd53a547d27e8689a3eb 1d7453411e1161e6da0fc30db0230cc4fd13097e \
                59371409bad76f82290a9a5b90576d3d99b4c7f5 2d78fd21a17ad258861ecc92ffb8ab6589d32be9 \
                e9906ec34a58c7bef272712568bb5a2c101b6595 2171f5dc27bdba15c1bfbe3ed98e79b125ff8691 \
                9f5c602e023dff7d8f72c95ef7b1a210b2663f66 aaea09f8b2002b9c48ea37154cc6ef27b5cff90c \
                dc20617d6a8984f12fa63a8809605cdae9f0bf80 26546930e138fa870a4abfa456f6980328caf90c \
                016be7a2433c35b569c730624528cdf0af522644 897b8d273d0d1ffb40982c7fb0ff19b57959d1c9 \
                378b6d106e7c807d2dfda658f9012fb5304b84de 55e4497676696242eae2e80d71543499483ce9d6 \
                c044087654d29fb47ff00992ce27becd8f196dd1

# cd ../platform_packages_providers_DownloadProvider
# git cherry-pick

cd ../platform_packages_providers_MediaProvider
git cherry-pick cb9b1b822fa9af6bca30a0aa433ab63fa6a66580 c41508ed0b45eca77d22a7ae89d5befcc0346441 \
                d31252edae6299e050996c8bb24b7d773e9acca2
cd ../platform_system_core
git cherry-pick 95d999cdbd4ad9423ed68119da3e308e90c8e6dd 43307989b95067ce91e05dc0bebe4c26d012de16 \
                04b28a01759803d62aacfe7feb1d5cbed16221f7 f7195a22117d1a5725697fe32f16c6567e0185a4 \

cd ../

for repo_name in "${repos_array[@]}"; do
    cd $repo_name
    git push origin HEAD:android-8.0 -f
    cd ../
done

echo
echo -e "${white}======================================================================"
echo -e "                          All jobs are done!"
echo -e "======================================================================"
read -p "Go to the main menu? [Y/n]: " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    clear
    cd ./scripts
    bash ./menu # small hack:)
else
    exit 1
fi