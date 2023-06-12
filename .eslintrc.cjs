/* eslint-env node */
module.exports = {
    extends: [
      'airbnb-base',
      'airbnb-typescript/base',
      'prettier'
    ],
    "parserOptions": {
      "project": "tsconfig.eslint.json"
    },
    "overrides": [
      {
        "files": ["scripts/*.ts"],
        "rules": {
          "no-console": 0
        }
      }
    ]
  };