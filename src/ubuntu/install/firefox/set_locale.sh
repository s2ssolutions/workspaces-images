#!/bin/bash

# Function to fetch the alpha-2 country code using ip-api.com
get_country_code() {
    curl -s http://ip-api.com/json | grep -oP '(?<="countryCode":")[^"]*'
}

# Comprehensive mapping of alpha-2 country codes to locale language codes
declare -A COUNTRY_LOCALES=(
    # Format: ["<alpha2>"]="<primary_locale>, <secondary_locale>"
    ["AF"]="fa, ps"       # Afghanistan
    ["AL"]="sq"           # Albania
    ["DZ"]="ar"           # Algeria
    ["AS"]="en"           # American Samoa
    ["AD"]="ca"           # Andorra
    ["AO"]="pt"           # Angola
    ["AI"]="en"           # Anguilla
    ["AG"]="en"           # Antigua and Barbuda
    ["AR"]="es"           # Argentina
    ["AM"]="hy"           # Armenia
    ["AW"]="nl"           # Aruba
    ["AU"]="en"           # Australia
    ["AT"]="de"           # Austria
    ["AZ"]="az"           # Azerbaijan
    ["BS"]="en"           # Bahamas
    ["BH"]="ar"           # Bahrain
    ["BD"]="bn"           # Bangladesh
    ["BB"]="en"           # Barbados
    ["BY"]="be, ru"       # Belarus
    ["BE"]="nl, fr"       # Belgium
    ["BZ"]="en, es"       # Belize
    ["BJ"]="fr"           # Benin
    ["BM"]="en"           # Bermuda
    ["BT"]="dz"           # Bhutan
    ["BO"]="es, qu"       # Bolivia
    ["BA"]="bs, hr, sr"   # Bosnia and Herzegovina
    ["BW"]="en, tn"       # Botswana
    ["BR"]="pt"           # Brazil
    ["BN"]="ms"           # Brunei
    ["BG"]="bg"           # Bulgaria
    ["BF"]="fr"           # Burkina Faso
    ["BI"]="fr, rn"       # Burundi
    ["KH"]="km"           # Cambodia
    ["CM"]="fr, en"       # Cameroon
    ["CA"]="en, fr"       # Canada
    ["CV"]="pt"           # Cape Verde
    ["CF"]="fr, sg"       # Central African Republic
    ["TD"]="fr, ar"       # Chad
    ["CL"]="es"           # Chile
    ["CN"]="zh"           # China
    ["CO"]="es"           # Colombia
    ["KM"]="ar, fr"       # Comoros
    ["CG"]="fr"           # Congo
    ["CD"]="fr"           # Congo (Dem. Rep.)
    ["CR"]="es"           # Costa Rica
    ["CI"]="fr"           # Côte d'Ivoire
    ["HR"]="hr"           # Croatia
    ["CU"]="es"           # Cuba
    ["CY"]="el, tr"       # Cyprus
    ["CZ"]="cs"           # Czech Republic
    ["DK"]="da"           # Denmark
    ["DJ"]="fr, ar, so"   # Djibouti
    ["DM"]="en"           # Dominica
    ["DO"]="es"           # Dominican Republic
    ["EC"]="es"           # Ecuador
    ["EG"]="ar"           # Egypt
    ["SV"]="es"           # El Salvador
    ["GQ"]="es, fr, pt"   # Equatorial Guinea
    ["ER"]="ti, ar, en"   # Eritrea
    ["EE"]="et"           # Estonia
    ["SZ"]="en, ss"       # Eswatini
    ["ET"]="am, om"       # Ethiopia
    ["FJ"]="en, fj"       # Fiji
    ["FI"]="fi, sv"       # Finland
    ["FR"]="fr"           # France
    ["GA"]="fr"           # Gabon
    ["GM"]="en"           # Gambia
    ["GE"]="ka"           # Georgia
    ["DE"]="de"           # Germany
    ["GH"]="en"           # Ghana
    ["GR"]="el"           # Greece
    ["GD"]="en"           # Grenada
    ["GT"]="es"           # Guatemala
    ["GN"]="fr"           # Guinea
    ["GW"]="pt"           # Guinea-Bissau
    ["GY"]="en"           # Guyana
    ["HT"]="fr, ht"       # Haiti
    ["HN"]="es"           # Honduras
    ["HK"]="zh, en"       # Hong Kong
    ["HU"]="hu"           # Hungary
    ["IS"]="is"           # Iceland
    ["IN"]="hi, en"       # India
    ["ID"]="id"           # Indonesia
    ["IR"]="fa"           # Iran
    ["IQ"]="ar, ku"       # Iraq
    ["IE"]="en, ga"       # Ireland
    ["IL"]="he, ar"       # Israel
    ["IT"]="it"           # Italy
    ["JM"]="en"           # Jamaica
    ["JP"]="ja"           # Japan
    ["JO"]="ar"           # Jordan
    ["KZ"]="kk, ru"       # Kazakhstan
    ["KE"]="en, sw"       # Kenya
    ["KI"]="en"           # Kiribati
    ["KP"]="ko"           # North Korea
    ["KR"]="ko"           # South Korea
    ["KW"]="ar"           # Kuwait
    ["KG"]="ky, ru"       # Kyrgyzstan
    ["LA"]="lo"           # Laos
    ["LV"]="lv"           # Latvia
    ["LB"]="ar, fr"       # Lebanon
    ["LS"]="en, st"       # Lesotho
    ["LR"]="en"           # Liberia
    ["LY"]="ar"           # Libya
    ["LI"]="de"           # Liechtenstein
    ["LT"]="lt"           # Lithuania
    ["LU"]="fr, de, lb"   # Luxembourg
    ["MO"]="zh, pt"       # Macao
    ["MG"]="fr, mg"       # Madagascar
    ["MW"]="en, ny"       # Malawi
    ["MY"]="ms, en"       # Malaysia
    ["MV"]="dv"           # Maldives
    ["ML"]="fr"           # Mali
    ["MT"]="mt, en"       # Malta
    ["MH"]="en, mh"       # Marshall Islands
    ["MQ"]="fr"           # Martinique
    ["MR"]="ar, fr"       # Mauritania
    ["MU"]="mfe, en, fr"  # Mauritius
    ["MX"]="es"           # Mexico
    ["FM"]="en"           # Micronesia
    ["MD"]="ro"           # Moldova
    ["MC"]="fr"           # Monaco
    ["MN"]="mn"           # Mongolia
    ["ME"]="sr, hr"       # Montenegro
    ["MA"]="ar, fr"       # Morocco
    ["MZ"]="pt"           # Mozambique
    ["MM"]="my"           # Myanmar
    ["NA"]="en, af"       # Namibia
    ["NR"]="na"           # Nauru
    ["NP"]="ne"           # Nepal
    ["NL"]="nl"           # Netherlands
    ["NZ"]="en, mi"       # New Zealand
    ["NI"]="es"           # Nicaragua
    ["NE"]="fr"           # Niger
    ["NG"]="en"           # Nigeria
    ["NO"]="no, nb"       # Norway
    ["OM"]="ar"           # Oman
    ["PK"]="ur, en"       # Pakistan
    ["PW"]="en"           # Palau
    ["PS"]="ar"           # Palestine
    ["PA"]="es"           # Panama
    ["PG"]="en, ho"       # Papua New Guinea
    ["PY"]="es, gn"       # Paraguay
    ["PE"]="es, qu"       # Peru
    ["PH"]="en, tl"       # Philippines
    ["PL"]="pl"           # Poland
    ["PT"]="pt"           # Portugal
    ["QA"]="ar"           # Qatar
    ["RO"]="ro"           # Romania
    ["RU"]="ru"           # Russia
    ["RW"]="rw, en, fr"   # Rwanda
    ["SA"]="ar"           # Saudi Arabia
    ["SB"]="en"           # Solomon Islands
    ["SC"]="en, fr"       # Seychelles
    ["SD"]="ar, en"       # Sudan
    ["SE"]="sv"           # Sweden
    ["SG"]="en, ms, zh, ta" # Singapore
    ["SH"]="en"           # Saint Helena
    ["SI"]="sl"           # Slovenia
    ["SJ"]="no"           # Svalbard and Jan Mayen
    ["SK"]="sk"           # Slovakia
    ["SL"]="en"           # Sierra Leone
    ["SM"]="it"           # San Marino
    ["SN"]="fr"           # Senegal
    ["SO"]="so, ar"       # Somalia
    ["SR"]="nl"           # Suriname
    ["SS"]="en"           # South Sudan
    ["ST"]="pt"           # São Tomé and Príncipe
    ["SV"]="es"           # El Salvador
    ["SX"]="nl, en"       # Sint Maarten
    ["SY"]="ar"           # Syria
    ["SZ"]="en, ss"       # Eswatini (Swaziland)
    ["TC"]="en"           # Turks and Caicos Islands
    ["TD"]="fr, ar"       # Chad
    ["TF"]="fr"           # French Southern and Antarctic Lands
    ["TG"]="fr"           # Togo
    ["TH"]="th"           # Thailand
    ["TJ"]="tg, ru"       # Tajikistan
    ["TK"]="en"           # Tokelau
    ["TL"]="pt, tet"      # Timor-Leste
    ["TM"]="tk, ru"       # Turkmenistan
    ["TN"]="ar"           # Tunisia
    ["TO"]="en, toh"      # Tonga
    ["TR"]="tr"           # Turkey
    ["TT"]="en"           # Trinidad and Tobago
    ["TV"]="en"           # Tuvalu
    ["TZ"]="sw, en"       # Tanzania
    ["UA"]="uk"           # Ukraine
    ["UG"]="en, sw"       # Uganda
    ["UM"]="en"           # U.S. Minor Outlying Islands
    ["US"]="en"           # United States
    ["UY"]="es"           # Uruguay
    ["UZ"]="uz, ru"       # Uzbekistan
    ["VA"]="it, la"       # Vatican City (Holy See)
    ["VC"]="en"           # Saint Vincent and the Grenadines
    ["VE"]="es"           # Venezuela
    ["VG"]="en"           # British Virgin Islands
    ["VI"]="en"           # U.S. Virgin Islands
    ["VN"]="vi"           # Vietnam
    ["VU"]="bi, en, fr"   # Vanuatu
    ["WF"]="fr"           # Wallis and Futuna
    ["WS"]="sm, en"       # Samoa
    ["YE"]="ar"           # Yemen
    ["YT"]="fr"           # Mayotte
    ["ZA"]="af, en, zu, xh" # South Africa
    ["ZM"]="en"           # Zambia
    ["ZW"]="en, sn, nd"   # Zimbabwe
)

# Function to update Firefox prefs.js
update_firefox_prefs() {
    LOCAL_PREFERENCES="/home/temp-user/.mozilla/firefox/kasm/user.js"
    LOCALES=$1

    # Check if the intl.accept_languages line exists
    if grep -q 'user_pref("intl.accept_languages"' "$LOCAL_PREFERENCES"; then
        # Replace the existing line
        sed -i "s/user_pref(\"intl.accept_languages\".*/user_pref(\"intl.accept_languages\", \"$LOCALES\");/" "$LOCAL_PREFERENCES"
    else
        # Add the line to the end of the file
        echo "user_pref(\"intl.accept_languages\", \"$LOCALES\");" >> "$LOCAL_PREFERENCES"
    fi
}

# Main logic
COUNTRY_CODE=$(get_country_code)
LOCALES=${COUNTRY_LOCALES[$COUNTRY_CODE]}

if [[ -z "$LOCALES" ]]; then
    echo "No locale mapping found for country code: $COUNTRY_CODE"
    exit 1
fi

echo "Detected country code: $COUNTRY_CODE"
echo "Mapped locales: $LOCALES"

# Update Firefox preferences
update_firefox_prefs "$LOCALES"
echo "Firefox preferences updated successfully."