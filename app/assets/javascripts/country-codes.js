var isoCountries = {
    'AF': 'Afghanistan',
    'AX': 'Aland Islands',
    'AL': 'Albania',
    'DZ': 'Algeria',
    'AS': 'American Samoa',
    'AD': 'Andorra',
    'AO': 'Angola',
    'AI': 'Anguilla',
    'AQ': 'Antarctica',
    'AG': 'Antigua And Barbuda',
    'AR': 'Argentina',
    'AM': 'Armenia',
    'AW': 'Aruba',
    'AU': 'Australia',
    'AT': 'Austria',
    'AZ': 'Azerbaijan',
    'BS': 'Bahamas',
    'BH': 'Bahrain',
    'BD': 'Bangladesh',
    'BB': 'Barbados',
    'BY': 'Belarus',
    'BE': 'Belgium',
    'BZ': 'Belize',
    'BJ': 'Benin',
    'BM': 'Bermuda',
    'BT': 'Bhutan',
    'BO': 'Bolivia',
    'BA': 'Bosnia And Herzegovina',
    'BW': 'Botswana',
    'BV': 'Bouvet Island',
    'BR': 'Brazil',
    'IO': 'British Indian Ocean Territory',
    'BN': 'Brunei Darussalam',
    'BG': 'Bulgaria',
    'BF': 'Burkina Faso',
    'BI': 'Burundi',
    'KH': 'Cambodia',
    'CM': 'Cameroon',
    'CA': 'Canada',
    'CV': 'Cape Verde',
    'KY': 'Cayman Islands',
    'CF': 'Central African Republic',
    'TD': 'Chad',
    'CL': 'Chile',
    'CN': 'China',
    'CX': 'Christmas Island',
    'CC': 'Cocos (Keeling) Islands',
    'CO': 'Colombia',
    'KM': 'Comoros',
    'CG': 'Congo',
    'CD': 'Congo, Democratic Republic',
    'CK': 'Cook Islands',
    'CR': 'Costa Rica',
    'CI': 'Cote D\'Ivoire',
    'HR': 'Croatia',
    'CU': 'Cuba',
    'CY': 'Cyprus',
    'CZ': 'Czech Republic',
    'DK': 'Denmark',
    'DJ': 'Djibouti',
    'DM': 'Dominica',
    'DO': 'Dominican Republic',
    'EC': 'Ecuador',
    'EG': 'Egypt',
    'SV': 'El Salvador',
    'GQ': 'Equatorial Guinea',
    'ER': 'Eritrea',
    'EE': 'Estonia',
    'ET': 'Ethiopia',
    'FK': 'Falkland Islands (Malvinas)',
    'FO': 'Faroe Islands',
    'FJ': 'Fiji',
    'FI': 'Finland',
    'FR': 'France',
    'GF': 'French Guiana',
    'PF': 'French Polynesia',
    'TF': 'French Southern Territories',
    'GA': 'Gabon',
    'GM': 'Gambia',
    'GE': 'Georgia',
    'DE': 'Germany',
    'GH': 'Ghana',
    'GI': 'Gibraltar',
    'GR': 'Greece',
    'GL': 'Greenland',
    'GD': 'Grenada',
    'GP': 'Guadeloupe',
    'GU': 'Guam',
    'GT': 'Guatemala',
    'GG': 'Guernsey',
    'GN': 'Guinea',
    'GW': 'Guinea-Bissau',
    'GY': 'Guyana',
    'HT': 'Haiti',
    'HM': 'Heard Island & Mcdonald Islands',
    'VA': 'Holy See (Vatican City State)',
    'HN': 'Honduras',
    'HK': 'Hong Kong',
    'HU': 'Hungary',
    'IS': 'Iceland',
    'IN': 'India',
    'ID': 'Indonesia',
    'IR': 'Iran, Islamic Republic Of',
    'IQ': 'Iraq',
    'IE': 'Ireland',
    'IM': 'Isle Of Man',
    'IL': 'Israel',
    'IT': 'Italy',
    'JM': 'Jamaica',
    'JP': 'Japan',
    'JE': 'Jersey',
    'JO': 'Jordan',
    'KZ': 'Kazakhstan',
    'KE': 'Kenya',
    'KI': 'Kiribati',
    'KR': 'Korea',
    'KW': 'Kuwait',
    'KG': 'Kyrgyzstan',
    'LA': 'Lao People\'s Democratic Republic',
    'LV': 'Latvia',
    'LB': 'Lebanon',
    'LS': 'Lesotho',
    'LR': 'Liberia',
    'LY': 'Libyan Arab Jamahiriya',
    'LI': 'Liechtenstein',
    'LT': 'Lithuania',
    'LU': 'Luxembourg',
    'MO': 'Macao',
    'MK': 'Macedonia',
    'MG': 'Madagascar',
    'MW': 'Malawi',
    'MY': 'Malaysia',
    'MV': 'Maldives',
    'ML': 'Mali',
    'MT': 'Malta',
    'MH': 'Marshall Islands',
    'MQ': 'Martinique',
    'MR': 'Mauritania',
    'MU': 'Mauritius',
    'YT': 'Mayotte',
    'MX': 'Mexico',
    'FM': 'Micronesia, Federated States Of',
    'MD': 'Moldova',
    'MC': 'Monaco',
    'MN': 'Mongolia',
    'ME': 'Montenegro',
    'MS': 'Montserrat',
    'MA': 'Morocco',
    'MZ': 'Mozambique',
    'MM': 'Myanmar',
    'NA': 'Namibia',
    'NR': 'Nauru',
    'NP': 'Nepal',
    'NL': 'Netherlands',
    'AN': 'Netherlands Antilles',
    'NC': 'New Caledonia',
    'NZ': 'New Zealand',
    'NI': 'Nicaragua',
    'NE': 'Niger',
    'NG': 'Nigeria',
    'NU': 'Niue',
    'NF': 'Norfolk Island',
    'MP': 'Northern Mariana Islands',
    'NO': 'Norway',
    'OM': 'Oman',
    'PK': 'Pakistan',
    'PW': 'Palau',
    'PS': 'Palestinian Territory, Occupied',
    'PA': 'Panama',
    'PG': 'Papua New Guinea',
    'PY': 'Paraguay',
    'PE': 'Peru',
    'PH': 'Philippines',
    'PN': 'Pitcairn',
    'PL': 'Poland',
    'PT': 'Portugal',
    'PR': 'Puerto Rico',
    'QA': 'Qatar',
    'RE': 'Reunion',
    'RO': 'Romania',
    'RU': 'Russian Federation',
    'RW': 'Rwanda',
    'BL': 'Saint Barthelemy',
    'SH': 'Saint Helena',
    'KN': 'Saint Kitts And Nevis',
    'LC': 'Saint Lucia',
    'MF': 'Saint Martin',
    'PM': 'Saint Pierre And Miquelon',
    'VC': 'Saint Vincent And Grenadines',
    'WS': 'Samoa',
    'SM': 'San Marino',
    'ST': 'Sao Tome And Principe',
    'SA': 'Saudi Arabia',
    'SN': 'Senegal',
    'RS': 'Serbia',
    'SC': 'Seychelles',
    'SL': 'Sierra Leone',
    'SG': 'Singapore',
    'SK': 'Slovakia',
    'SI': 'Slovenia',
    'SB': 'Solomon Islands',
    'SO': 'Somalia',
    'ZA': 'South Africa',
    'GS': 'South Georgia And Sandwich Isl.',
    'ES': 'Spain',
    'LK': 'Sri Lanka',
    'SD': 'Sudan',
    'SR': 'Suriname',
    'SJ': 'Svalbard And Jan Mayen',
    'SZ': 'Swaziland',
    'SE': 'Sweden',
    'CH': 'Switzerland',
    'SY': 'Syrian Arab Republic',
    'TW': 'Taiwan',
    'TJ': 'Tajikistan',
    'TZ': 'Tanzania',
    'TH': 'Thailand',
    'TL': 'Timor-Leste',
    'TG': 'Togo',
    'TK': 'Tokelau',
    'TO': 'Tonga',
    'TT': 'Trinidad And Tobago',
    'TN': 'Tunisia',
    'TR': 'Turkey',
    'TM': 'Turkmenistan',
    'TC': 'Turks And Caicos Islands',
    'TV': 'Tuvalu',
    'UG': 'Uganda',
    'UA': 'Ukraine',
    'AE': 'United Arab Emirates',
    'GB': 'United Kingdom',
    'US': 'United States',
    'UM': 'United States Outlying Islands',
    'UY': 'Uruguay',
    'UZ': 'Uzbekistan',
    'VU': 'Vanuatu',
    'VE': 'Venezuela',
    'VN': 'Viet Nam',
    'VG': 'Virgin Islands, British',
    'VI': 'Virgin Islands, U.S.',
    'WF': 'Wallis And Futuna',
    'EH': 'Western Sahara',
    'YE': 'Yemen',
    'ZM': 'Zambia',
    'ZW': 'Zimbabwe'
};

var langCodes = {
    "af": "Afrikaans",
    "sq": "Albanian",
    "ar": "Arabic (Standard)",
    "ar_dz": "Arabic (Algeria)",
    "ar_bh": "Arabic (Bahrain)",
    "ar_eg": "Arabic (Egypt)",
    "ar_iq": "Arabic (Iraq)",
    "ar_jo": "Arabic (Jordan)",
    "ar_kw": "Arabic (Kuwait)",
    "ar_lb": "Arabic (Lebanon)",
    "ar_ly": "Arabic (Libya)",
    "ar_ma": "Arabic (Morocco)",
    "ar_om": "Arabic (Oman)",
    "ar_qa": "Arabic (Qatar)",
    "ar_sa": "Arabic (Saudi Arabia)",
    "ar_sy": "Arabic (Syria)",
    "ar_tn": "Arabic (Tunisia)",
    "ar_ae": "Arabic (U.A.E.)",
    "ar_ye": "Arabic (Yemen)",
    "ar": "Aragonese",
    "hy": "Armenian",
    "as": "Assamese",
    "ast": "Asturian",
    "az": "Azerbaijani",
    "eu": "Basque",
    "bg": "Bulgarian",
    "be": "Belarusian",
    "bn": "Bengali",
    "bs": "Bosnian",
    "br": "Breton",
    "bg": "Bulgarian",
    "my": "Burmese",
    "ca": "Catalan",
    "ch": "Chamorro",
    "ce": "Chechen",
    "zh": "Chinese",
    "zh_hk": "Chinese (Hong Kong)",
    "zh_cn": "Chinese (PRC)",
    "zh_sg": "Chinese (Singapore)",
    "zh_tw": "Chinese (Taiwan)",
    "cv": "Chuvash",
    "co": "Corsican",
    "cr": "Cree",
    "hr": "Croatian",
    "cs": "Czech",
    "da": "Danish",
    "nl": "Dutch (Standard)",
    "nl_be": "Dutch (Belgian)",
    "en": "English",
    "en_au": "English (Australia)",
    "en_bz": "English (Belize)",
    "en_ca": "English (Canada)",
    "en_ie": "English (Ireland)",
    "en_jm": "English (Jamaica)",
    "en_nz": "English (New Zealand)",
    "en_ph": "English (Philippines)",
    "en_za": "English (South Africa)",
    "en_tt": "English (Trinidad & Tobago)",
    "en_gb": "English (United Kingdom)",
    "en_us": "English (United States)",
    "en_zw": "English (Zimbabwe)",
    "eo": "Esperanto",
    "et": "Estonian",
    "fo": "Faeroese",
    "fa": "Farsi",
    "fj": "Fijian",
    "fi": "Finnish",
    "fr": "French (Standard)",
    "fr_be": "French (Belgium)",
    "fr_ca": "French (Canada)",
    "fr_fr": "French (France)",
    "fr_lu": "French (Luxembourg)",
    "fr_mc": "French (Monaco)",
    "fr_ch": "French (Switzerland)",
    "fy": "Frisian",
    "fur": "Friulian",
    "gd": "Gaelic (Scots)",
    "gd_ie": "Gaelic (Irish)",
    "gl": "Galacian",
    "ka": "Georgian",
    "de": "German (Standard)",
    "de_at": "German (Austria)",
    "de_de": "German (Germany)",
    "de_li": "German (Liechtenstein)",
    "de_lu": "German (Luxembourg)",
    "de_ch": "German (Switzerland)",
    "el": "Greek",
    "gu": "Gujurati",
    "ht": "Haitian",
    "he": "Hebrew",
    "hi": "Hindi",
    "hu": "Hungarian",
    "is": "Icelandic",
    "id": "Indonesian",
    "iu": "Inuktitut",
    "ga": "Irish",
    "it": "Italian (Standard)",
    "it_ch": "Italian (Switzerland)",
    "ja": "Japanese",
    "kn": "Kannada",
    "ks": "Kashmiri",
    "kk": "Kazakh",
    "km": "Khmer",
    "ky": "Kirghiz",
    "tlh": "Klingon",
    "ko": "Korean",
    "ko_kp": "Korean (North Korea)",
    "ko_kr": "Korean (South Korea)",
    "la": "Latin",
    "lv": "Latvian",
    "lt": "Lithuanian",
    "lb": "Luxembourgish",
    "mk": "FYRO Macedonian",
    "ms": "Malay",
    "ml": "Malayalam",
    "mt": "Maltese",
    "mi": "Maori",
    "mr": "Marathi",
    "mo": "Moldavian",
    "nv": "Navajo",
    "ng": "Ndonga",
    "ne": "Nepali",
    "no": "Norwegian",
    "nb": "Norwegian (Bokmal)",
    "nn": "Norwegian (Nynorsk)",
    "oc": "Occitan",
    "or": "Oriya",
    "om": "Oromo",
    "fa": "Persian",
    "fa_ir": "Persian/Iran",
    "pl": "Polish",
    "pt": "Portuguese",
    "pt_br": "Portuguese (Brazil)",
    "pa": "Punjabi",
    "pa_in": "Punjabi (India)",
    "pa_pk": "Punjabi (Pakistan)",
    "qu": "Quechua",
    "rm": "Rhaeto-Romanic",
    "ro": "Romanian",
    "ro_mo": "Romanian (Moldavia)",
    "ru": "Russian",
    "ru_mo": "Russian (Moldavia)",
    "sz": "Sami (Lappish)",
    "sg": "Sango",
    "sa": "Sanskrit",
    "sc": "Sardinian",
    "gd": "Scots Gaelic",
    "sd": "Sindhi",
    "si": "Singhalese",
    "sr": "Serbian",
    "sk": "Slovak",
    "sl": "Slovenian",
    "so": "Somani",
    "sb": "Sorbian",
    "es": "Spanish",
    "es_ar": "Spanish (Argentina)",
    "es_bo": "Spanish (Bolivia)",
    "es_cl": "Spanish (Chile)",
    "es_co": "Spanish (Colombia)",
    "es_cr": "Spanish (Costa Rica)",
    "es_do": "Spanish (Dominican Republic)",
    "es_ec": "Spanish (Ecuador)",
    "es_sv": "Spanish (El Salvador)",
    "es_gt": "Spanish (Guatemala)",
    "es_hn": "Spanish (Honduras)",
    "es_la": "Spanish (Latin America)",
    "es_mx": "Spanish (Mexico)",
    "es_ni": "Spanish (Nicaragua)",
    "es_pa": "Spanish (Panama)",
    "es_py": "Spanish (Paraguay)",
    "es_pe": "Spanish (Peru)",
    "es_pr": "Spanish (Puerto Rico)",
    "es_es": "Spanish (Spain)",
    "es_uy": "Spanish (Uruguay)",
    "es_ve": "Spanish (Venezuela)",
    "sx": "Sutu",
    "sw": "Swahili",
    "sv": "Swedish",
    "sv_fi": "Swedish (Finland)",
    "sv_sv": "Swedish (Sweden)",
    "ta": "Tamil",
    "tt": "Tatar",
    "te": "Teluga",
    "th": "Thai",
    "tig": "Tigre",
    "ts": "Tsonga",
    "tn": "Tswana",
    "tr": "Turkish",
    "tk": "Turkmen",
    "uk": "Ukrainian",
    "hsb": "Upper Sorbian",
    "ur": "Urdu",
    "ve": "Venda",
    "vi": "Vietnamese",
    "vo": "Volapuk",
    "wa": "Walloon",
    "cy": "Welsh",
    "xh": "Xhosa",
    "ji": "Yiddish",
    "zu": "Zulu",
};

function getCountryName(countryCode) {
    if (isoCountries.hasOwnProperty(countryCode)) {
        return isoCountries[countryCode];
    } else {
        return countryCode;
    }
}

function getLanguage(langCode) {
    if (langCodes.hasOwnProperty(langCode)) {
        return langCodes[langCode];
    } else if (langCodes.hasOwnProperty(langCode.substring(0, 2))) {
        return langCodes[langCode.substring(0, 2)];
    }else {
        return langCode;
    }
}
