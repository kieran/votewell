import i18n from 'i18next'
import {
  initReactI18next
} from 'react-i18next'

export languages =
  en: 'English'
  cy: 'Cymraeg'

import en from './en'
import cy from './cy'

export default \
i18n
.use initReactI18next # passes i18n down to react-i18next
.init(
  resources: { en, cy }
  fallbackLng: 'en'
  nsSeparator: ''
  debug: false
  keySeparator: false # we do not use keys in form messages.welcome
  interpolation:
    escapeValue: false # react already safes from xss
  react:
    useSuspense: false
)
