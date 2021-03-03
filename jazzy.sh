mkdir -p docs
sourcekitten doc --spm --module-name Storage > docs/Storage.json
sourcekitten doc --spm --module-name Keychain > docs/Keychain.json
sourcekitten doc --spm --module-name UserDefault > docs/UserDefault.json
sourcekitten doc --spm --module-name Singleton > docs/Singleton.json
sourcekitten doc --spm --module-name Inject > docs/Inject.json
jazzy --config .jazzy.yml
