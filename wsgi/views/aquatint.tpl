<!DOCTYPE html>
<html>
<head>
    <title>File Upload Form</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f2f2f2;
        }
        form {
            width: 400px;
            margin: 0 auto;
            padding: 20px;
            background-color: #fff;
            border: 1px solid #ccc;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.2);
        }
        h1 {
            color: green;
        }
        h3 {
            color: #333;
        }
        input[type="file"] {
            margin: 10px 0;
        }
        input[type="submit"] {
            background-color: #007bff;
            color: #fff;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
        }
        input[type="submit"]:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <form action="/app/aquatint" method="post" enctype="multipart/form-data" accept-charset="UTF-8">
        <h1>SpacePhysics.org</h1>
        <h3>Uploading File Form</h3>
        <input type="file" name="file">
        <input type="submit" value="Upload File">
    </form>
</body>
</html>

