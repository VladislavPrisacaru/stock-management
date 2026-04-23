import sys
from PySide6.QtWidgets import QApplication
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtQuickControls2 import QQuickStyle
from backend.Database import Database as db
from backend.Logic import Backend

app = QApplication(sys.argv)    
engine = QQmlApplicationEngine()
QQuickStyle.setStyle("Material") # set the inbuild style

db = db("GLHdb.db") # define the global database and pass it to the logic class
backend = Backend(db)

engine.rootContext().setContextProperty("backend", backend) # expose the backedn class to the ui

engine.load("qmlproj/qmlproj/Main.qml") # load the ui engine

if not engine.rootObjects(): # if no pages close the app
    sys.exit(-1)

sys.exit(app.exec()) 