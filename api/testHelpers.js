const testHelpers = {
  normalize: (text) => {
    return text.replace(/\s/g, "").toLowerCase();
  },
  mockRouter: () => {
    return {
      get: jest.fn(),
      post: jest.fn(),
      put: jest.fn(),
      delete: jest.fn()
    };
  },
  mockRepo: () => {
    return {
      account: {
        selectAll: jest.fn(),
        insert: jest.fn(),
        update: jest.fn(),
        delete: jest.fn()
      }
    };
  },
  mockRequest: () => {

  },
  mockResult: () => {
    return {
      json: jest.fn()
    };
  }
};

module.exports = testHelpers;