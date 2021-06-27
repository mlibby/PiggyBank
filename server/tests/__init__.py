from server import create_app


def client():
    app = create_app("testing")
    with app.test_client() as client:
        return client
