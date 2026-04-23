// ProductForm.qml

import QtQuick 
import QtQuick.Controls 
import QtQuick.Layouts 
import "../Components" as UI 

Item {
    id: productForm
    visible: false
    anchors.fill: parent

    property string errorMessage: ""
    property string mode: "Add" // can be "Add" or "Edit"
    property var product: null // the product being edited, or null if adding a new one

    onVisibleChanged: {
        if (mode === "Edit" && product) {
            productName.inputText = product.productName
            productPrice.inputText = product.price
            productStock.inputText = product.stock
        }
    }

    Rectangle { // background overlay
        id: productFormBG

        anchors.fill: parent
        
        color: "#80000000" // semi-transparent dark overlay

        MouseArea { // clicking outside the form will close it
            anchors.fill: parent
            onClicked: {
                return // prevent closing when clicking the background
            }
        }

        Rectangle { // form container
            id: formContainer
            anchors.centerIn: parent
            width: 400
            height: 500
            color: "white"
            radius: 8

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 20                             

                Text {text: mode === "Add" ? "Add Product" : "Edit Product"}

                Label {
                    text: errorMessage
                    color: "red"
                    visible: errorMessage !== ""
                }

                UI.InputRow { id: productName; labelText: "Product Name:"; } // labeled inputs
                UI.InputRow { id: productPrice; labelText: "Product Price:"; } 
                UI.InputRow { id: productStock; labelText: "Product Stock:"; } 

                Item {Layout.fillHeight: true}

                RowLayout {

                    spacing: 10
                    Layout.fillWidth: true

                    UI.AppButton {
                        btnText: "Cancel"
                        Layout.fillWidth: true
                        onClicked: {
                            productForm.visible = false
                            clearFields()
                        }
                    }

                    UI.AppButton {
                        btnText: "Delete"
                        Layout.fillWidth: true
                        visible: mode === "Edit" // only show delete button in edit mode
                        onClicked: {
                            backend.deleteProduct(product.productName)
                            console.log("Product deleted")
                            productForm.visible = false
                            clearFields()
                        }
                    }

                    UI.AppButton {
                        btnText: mode === "Add" ? "Add Product" : "Save Changes" // change button text depending on mode
                        Layout.fillWidth: true
                        onClicked: {
                            
                            if (!handleValidation()) { // if validation fails, return without doing anything
                                return
                            }

                            if (mode === "Add") {
                                backend.createProduct(productName.inputText, parseFloat(productPrice.inputText), parseInt(productStock.inputText))
                                console.log("Product added") // if in add mode, create a new product with the input values
                                clearFields()
                                productForm.visible = false
                                

                            } else if (mode === "Edit") {
                                console.log("Updating product: oldName='" + product.productName + "', newName='" + productName.inputText + "'")
                                backend.updateProduct(product.productId, productName.inputText, parseFloat(productPrice.inputText), parseInt(productStock.inputText))
                                console.log("Product updated") // if in edit mode, update the existing product with the new input values
                                // backend.refreshProducts()
                                clearFields()
                                productForm.visible = false
                            }
                        }
                    }
                }
            }
        }
    }

    function handleValidation () {
        if (!productName.inputText || !productPrice.inputText || !productStock.inputText) {
            console.log("All fields are required."); // if a field is empty show error message and return
            errorMessage = "All fields are required"
            return false;
        }

        if (isNaN(parseFloat(productPrice.inputText)) || isNaN(parseInt(productStock.inputText))) {
            console.log("Price must be a number and stock must be an integer."); // if price and stock inputs are not valid show error message and return
            errorMessage = "Price and stock must be a number"
            return false;
        }

        if (parseFloat(productPrice.inputText) < 0 || parseInt(productStock.inputText) < 0) {
            console.log("Price and stock cannot be negative."); // if price or stock are less than zero show error message and return
            errorMessage = "Price and stock cannot be negative"
            return false;
        }

        return true; // if all validation checks are passed, return true
    }

    function clearFields() {
        productName.inputText = "" 
        productPrice.inputText = ""
        productStock.inputText = ""
        errorMessage = ""
    }
}