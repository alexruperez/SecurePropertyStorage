mkdir -p docs
sourcekitten doc --spm-module Storage > docs/Storage.json
sourcekitten doc --spm-module Keychain > docs/Keychain.json
sourcekitten doc --spm-module UserDefault > docs/UserDefault.json
sourcekitten doc --spm-module Singleton > docs/Singleton.json
sourcekitten doc --spm-module Inject > docs/Inject.json
jazzy --config .jazzy.yml
