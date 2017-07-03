keepalived:
  vi_1_state: MASTER
  vi_2_state: BACKUP
  vi_1_priority: 150
  vi_2_priority: 100
  mcast_src_ip: {{ mcast_src_ip }}
#  mcast_src_ip: |
#    -----BEGIN PGP MESSAGE-----
#    Version: GnuPG v1
#    Comment: GPGTools - http://gpgtools.org
#
#    hQIMA4VjTU4mltuAAQ//TwaHgTYrNxShtHYlFoAk6NxChYzgBJa/C9WbXeIJ6DYU
#    bqlMrQnqIZ1kM9ns4pOIknO/Wv4Q55QavSHpjmd+m/McMalbjLuwmv6R6r56ECqq
#    baJbbtOoPdmtOEUox4AIdUCKEm+tUVYNj1fQ1gpww5nCZLKE95jMQo7tGqE6JQLQ
#    jPvlI4XhjGP8BCkRvdmyXAkd3fPjqFFHdISo49HK3bfraEX1GdjTXPXVNR8JS8Bz
#    d2s4NtaUpwxO1w5t471KvM6lO7lP9LHZMIAyyNPIyvRY75ACf6dm1K9UY71I/ZAQ
#    rBSI4lo40Kgn7kSv7Ccs3OdG6+406GkUgZ+7FttVM2JyxDJY1BT0wQyrLUbu3pTe
#    pcWsKyAAjkAAz3SoJjIvNbPp/uxrHVH1jl+W592sQolGpjWic6CVMd4/QLi+XxXy
#    cGDeh1lYm3fAeKXIiafmIGlGWHzf7hqNY97jHGfCVxJ18gQ2lAMZwkzZFNxYcVvY
#    ly4NkLgN8ISPbUKvxvHjujsmyG2RFxWvJpYpf2ymqpfRopU8u7v8djPsruYPE9J4
#    8WeEwAHzitPZaiUfwbtOnB5Wk6Pa9OdbptKv48GbGMKO4iDtZYbdi22PyXN5rmkV
#    AhqAwbj9pN0S5pYeBWvXxPkYsEJt37d/fIcgTvhEI2I6uaOr3bWu0pSrQyEHT2/S
#    SgF7HElxHf9x7i8QBDByQQeNPXS34m+ql5zsBLKQ0Sp+M944N2iYe4jqjHEA5kUk
#    l3wFi17vS4LlVSu1EituLxIMmXyFbmg2yBw9
#    =atrP
#    -----END PGP MESSAGE-----
  password: {{ keepalived_pass }}


#!yaml|gpg

keepalived:
  vi_1_state: BACKUP
  vi_2_state: MASTER
  vi_1_priority: 100
  vi_2_priority: 150
  mcast_src_ip: |
    -----BEGIN PGP MESSAGE-----
    Version: GnuPG v1
    Comment: GPGTools - http://gpgtools.org

    hQIMA4VjTU4mltuAAQ/9E5ug7U9AG8cPNReypUiF+3Mkt2SshIRVshgVN5i7MeIi
    guK1DSRHM2szQLdzIczOsct56lkWBNpkWB2rQjMCxKzzko/a2Uibr7hIpDlMEs/Q
    5RXEn/yge4tOM+CAcsON/NOaGbtvi7DGVolUBNp5PyvcWCE/FXPIBz0P9W6HwA2L
    pzhfZhVY3J1DiyP9sVSqFN1EBu1rZzSN+DKGOnWTH+Ns2u62BGjK3E9hMbIDvBKE
    kaKNJsK1dh5btIKXaarLUInRvl9sUaC57h83KtMAz6+Yjs0hv8HLHTujl992GrVX
    +0VjKXUn4BWXCXDAVfm+Fda67jb/zJITGIyswACi23q8cKT27se25XcKc1pyJNUW
    mWGZC8tuzZAfvN4BQhv+qTFIFjPER3/1FgQie0GvEjTxFqGQTG7YJ8LEOExax2et
    VeYHfgGAWyRRYlT/azNgfXjgDn7r8gHdiuzn1QWFoatUBQwfZL3hwd4iO7fvhJNb
    1anIGA90e1pboWvFYBQUJFwHk1oWvNYIOIGG/FlPvZtoHTfSXV16hKb5LVoUfdpJ
    7ZG/iPTWa1wGYZasvloqykAjlrafJBzCAldgk86lcLfVumbu5aJDyNHGq8lGfMDW
    774WWa8jFvhRjA85gj6VRgZkTqBaRZLdKR/l6IgTXj0x4EEkWRtymYOCKcBnb7rS
    SgFt3jnIZ55rUcCCHEF1UKGvzSY1zE5VIK5LJg/kbUJR+F+LITOAfXzrjR9ukXXS
    alIMpOsPZcAQrbVAyj8z1oh9h0Tcob6yS2u+
    =0qIW
    -----END PGP MESSAGE-----
  password: {{ keepalived_pass }}

