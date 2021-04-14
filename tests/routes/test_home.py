import unittest
from ...app import app


class BasicTests(unittest.TestCase):

    def test_home_index(self):
        response = self.app.get('/')
        self.assertEqual(response.status_code, 200)


if __name__ == "__main__":
    unittest.main()
