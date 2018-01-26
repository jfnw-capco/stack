""" HelloWorld : Python and Redis example """

from flask import Flask
from flask_restful import Resource, Api
from redis import Redis

app = Flask(__name__)
api = Api(app)
redis = Redis(host='db', port=6379)

class HelloWorld(Resource):
    def get(self):
        count = redis.incr('hits')
        return {'msg' : 'hello world!  I have been seen {0} times'.format(count)}

api.add_resource(HelloWorld, '/')

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=80, debug=True)