using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;
using Newtonsoft.Json;
using System.IO;
using Newtonsoft.Json.Bson;
using Newtonsoft.Json.Linq;


namespace SqlServer.Custom {
    [Serializable]
    [Microsoft.SqlServer.Server.SqlUserDefinedType(Format.UserDefined, Name = "JSON",MaxByteSize=8000)]
    public struct JSON : INullable, IBinarySerialize {

        public override string ToString() {
            if (this.IsNull) {
                return "NULL";
            }

            else {
                return this.Document.ToString();
            }
        }


        private SqlString _document;

        public SqlString Document {
            get {
                return _document;
            }

            set {
                _document = value;
            }
        }


        public bool IsNull {
            get {
                // Put your code here
                return _null;
            }
        }

        public static JSON Null {
            get {
                JSON h = new JSON();
                h._null = true;
                return h;
            }
        }

        public static JSON Parse(SqlString s) {
            if (s.IsNull)
                return Null;

            JSON u = new JSON();

            u.Document = s;

            return u;
        }



        public SqlString GetDocumentByAttributeValue(SqlString attributeName, SqlString value) {


            JToken document = JToken.Parse(this.Document.Value.ToString());

            this._found = false;

            bool searchOk = WalkNode(document, attributeName.Value.ToString(), value.Value.ToString(),this._found);

            if (searchOk) {
                return this.Document;
            }

            else {
                return SqlString.Null;
            }


        }

        private  bool _found;


        private bool WalkNode(JToken node, string propertyName, string value,bool found) {



            if (node.Type == JTokenType.Object) {


                foreach (JProperty child in node.Children<JProperty>()) {

                    if (child.Name.Equals(propertyName)) {
                        if (child.Value.ToString().Contains(value)) {

                            this._found = true;
                            return this._found;

                        }
                    }

                    if (!found) {
                        WalkNode(child.Value, propertyName, value,found);
                    }

                    else {
                        break;
                    }
                }
            }

            else {
                if (node.Type == JTokenType.Array) {
                    foreach (JToken child in node.Children()) {


                        if (child.Type == JTokenType.Array) {
                            if (!this._found) {
                                WalkNode(child, propertyName, value,found);
                            }
                        }

                        if (child.Type == JTokenType.Object) {
                            if (!this._found) {
                                WalkNode(child, propertyName, value,found);
                            }
                        }



                        else {
                            break;
                        }
                    }
                }

            }

            return this._found;
        }


        //  Private member
        private bool _null;

        public void Read(System.IO.BinaryReader r) {


            this.Document = r.ReadString();


        }

        public void Write(System.IO.BinaryWriter w) {

            try {

                JObject.Parse(this.Document.Value);

            }

            catch (Exception ex) {

                SqlContext.Pipe.Send(ex.Message);
                throw;
            }

            w.Write(this.Document.Value);

        }
    }
}