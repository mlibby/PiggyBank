module.exports = {
    collectCoverage: true,
    collectCoverageFrom: ["client/src/**/*.{js,vue}", "!client/src/main.js"],
    coverageDirectory: "coverage-vue",
    coverageReporters: ["html", "lcov"],

    // specifies aliases for imports
    moduleNameMapper: {
        "^@/(.*)$": "<rootDir>/client/src/$1",
        "^~/(.*)$": "<rootDir>/client/src/$1",
        "^vue$": "vue/dist/vue.common.js",
    },
    // specifies extensions of files that will be tested
    moduleFileExtensions: ["js", "vue", "json"],
    // specifies a regular extension that will be used to find test files in your project
    testRegex: "(/__tests__/.*|\\.(test|spec))\\.(js)$",
    // specifies that .js files must be transformed using babel-jest, and vue files must be transformed using vue-jest
    transform: {
        "^.+\\.js$": "babel-jest",
        ".*\\.(vue)$": "vue-jest",
    },
};
