export const mockFetch = jest.fn()

export const mockApiKeyCollection = jest.fn().mockImplementation(() => {
  return {
    fetch: mockFetch
  }
})

export const ApiKeyCollection = mockApiKeyCollection
