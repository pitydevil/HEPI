<div align="center">
  <h2>Fluffy</h2>
</div>

## Features

This repository ispacked with:

-   Swift 5.7
-   RxSwift 5.13
-   RxCocoa 5.13
-   Alamofire
-   Snapkit
-   SDWebImage
-   Cocoapods 1.13
-   SnapKit 5.0.0
-   IQKeyboardManagerSwift

# Getting Started

## Cocoapods dependency manager install, if you have installed it please just skip to step no. 3

### 1. Install ffi

```
sudo arch -x86_64 gem install ffi
```
### 2. Install cocoapod

'''
sudo arch -x86_64 gem install cocoapod
'''

### 3. Install project dependency

'''
sudo arch -x86_64 pod install
'''

### 4. Conflict Mitigation If Cocoapod Error

'''
sudo arch -x86_64 pod deintegrate 
sudo arch -x86_64 pod init
sudo arch -x86_64 pod install
'''


### 5. Commit Message Convention

This repository follows [Conventional Commit](https://www.conventionalcommits.org/en/v1.0.0/)
#### Format
`<type>(optional scope): <description>`
Contoh: `feat(dashboard): add button`

#### Type:

- feat → Kalo ada penambahan/pengurangan codingan
- fix → kalo ada bug fixing
- BREAKING CHANGE → kalo ada perubahan yang signifikan (ubah login flow)
- docs → update documentation (README.md)
- styling → update styling, ga ngubah logic sama sekali (reorder import, benerin whitespace)
- ci → update github workflow
- test → update testing
- perf → fix sesuatu yang bersifat cuma untuk performance issue (derived state, memo)

### 6. Branch Naming Rules
> **IMPORTANT:**
> - TERKONEKSI dengan JIRA maka gunakan format branch seperti format yang diberikan pada JIRA
> - CONTOH NAMING RULES dari JIRA

- MCMFF1-xx-lorem-ipsum-dolor-amit
- MCMFF1-xx-MC2FF1-yy-MC2FF1-zz-lorem-ipsum

### 7. Pull Request Title Naming Rules
> **IMPORTANT:**
> - Agar Terintegrasi dengan JIRA maka gunakan format penamaan pull request seperti contoh dibawah
> - Jika ingin menyelesaikan lebih dari 1 backlog di jira bisa dengan contoh urutan kedua dibawah
> - Gunakan Squash & Merge dan mengganti commit sesuai aturan conventional commit pada poin #3 di README

- MCMFF1-xx-lorem-ipsum-dolor-amit
- MCMFF1-xx-MC2FF1-yy-MC2FF1-zz-lorem-ipsum

### 8. Variable case convention
- Use `camelCase` for every situation
- Use `PascalCase` for file name
- Use 'snake_case' for metadata file

### 9. Directory Structure
> **IMPORTANT:**
> - use PascalCase for folder name & View Controller Name
> - use camelCase for Variables
```js
--Project Workspace
  |--Base
  |  |--App Delegate
  |  |--Scene Delegate
  |--Services
  |  |--Api Services
  |--Providers
  |  |--Base Provider
  |--Components
  |  |--SpecificLayout
  |  |--SharedLayout
  |--Miscellaneous
  |--Model
  |  |--Class Model
  |  |--API Model
  |--ViewModel
  |--Views
  |  |--home
  |  |--anotherpage
  |--Utils
  |  |--Extension
  |  |--Helper Class
```
