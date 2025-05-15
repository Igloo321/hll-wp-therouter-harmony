'use strict';

module.exports = {
  extension: ['ts'],
  require: 'ts-node/register',
  spec: process.env.TEST_ENV === 'unit' ? 'tests/**/Unit.test.ts' : 'tests/**/*.test.ts',
  recursive: true
}