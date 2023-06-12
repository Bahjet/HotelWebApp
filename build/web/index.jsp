<%-- 
    Document   : index
    Created on : 4 de jun. de 2023, 22:37:51
    Author     : Acer Nitro 5
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.User" %>

                    
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Vila Park</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-KK94CHFLLe+nY2dmCWGMq91rCGa5gtU4mk92HdvYe+M/SXH301p5ILy+dN9+nJOZ" crossorigin="anonymous">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
        <script src="https://unpkg.com/vue@next"></script>
        <style>
            .btn-finalizar:hover{
                transform: scale(1.05);
                background-color: red;
            }
        </style>
    </head>
    <body>
        <%@include file="WEB-INF/jspf/header.jspf" %>
        
        <div id="app" class="container-fluid m-2">
            <div v-if="shared.session">
                <div v-if="error" class="alert alert-danger m-2" role="alert">
                    {{error}}
                </div>
                <div v-else>
                    <%if(session.getAttribute("user")!=null){User u = (User) session.getAttribute("user");
                    if(u.getRole().equals("ADMIN")){%>
                    <h2>Registrar Estadia</h2>
                     
                         <div class="input-group mb-3">
                        <span class="input-group-text" id="basic-addon1"><i class="bi bi-clipboard-data"></i></span>
                        <input type="text" class="form-control" v-model="newPlate" placeholder="Placa">
                        <input type="text" class="form-control" v-model="newName" placeholder="Nome">
                        <input type="text" class="form-control" v-model="newNumber" placeholder="Suite">
                        <button class="btn btn-primary" type="button" @click="addStay"><i class="bi bi bi-check2"></i></button>
                    </div>
                    <%}%>
                   
                    <table class="table">
                        <tr>
                            <%if(u.getRole().equals("ADMIN")){%>
                            <th>PLACA</th>
                            <%}%>
                            <th>NOME</th>
                            <th>SUITE</th>
                            <%if(u.getRole().equals("ADMIN")){%>
                            <th>ENTRADA</th>
                            <th class="text-end">VALOR</th>
                            <th>SAIDA</th>
                            <%}%>
                        </tr>
                        <tr v-for="item in list" :key="item.rowId">
                            <%if(u.getRole().equals("ADMIN")){%>
                            <td>{{ item.vehiclePlate }}</td>
                            <%}%>
                            <td>{{ item.customerName }}</td>
                            <td>{{ item.roomNumber }}</td>
                            <%if(u.getRole().equals("ADMIN")){%>
                            <td>{{ item.beginStay }}</td>
                            <td class="text-end">
                                {{ getPrice(item.beginStay).toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' }) }}
                            </td>
                            <td>
                                <button type="button" @click="finishStay(item.rowId)" class="btn btn-danger btn-sm">
                                    <i class="bi bi-box-arrow-up"></i> <strong style="color: #fff">check-out</strong>
                                </button>
                            </td>
                            <%}%>
                        </tr>
                    </table>
                </div>
            </div>
             <%}%>
        </div>
        <script>
            const app = Vue.createApp({
                data() {
                    return {
                        shared: shared,
                        error: null,
                        now: new Date(),
                        newName: '', //newModel
                        newNumber: '', //newColor
                        newPlate: '',
                        hourPrice: 0.0,
                        list: [],
                    }
                },
                methods: {
                    async request(url = "", method, data) {
                        try{
                            const response = await fetch(url, {
                                method: method,
                                headers: {"Content-Type": "application/json"},
                                body: JSON.stringify(data)
                            });
                            if(response.status==200){
                                return response.json();
                            }else{
                                this.error = response.statusText;
                            }
                        } catch(e){
                            this.error = e;
                            return null;
                        }
                    },
                    async loadList() {
                        const data = await this.request("/HotelWebApp/api/hotel", "GET");
                        if(data) {
                            this.hourPrice = data.hourPrice;
                            this.list = data.list;
                        }
                    },
                    async addStay() {
                        const data = await this.request("/HotelWebApp/api/hotel", "POST", {name: this.newName, number: this.newNumber, plate: this.newPlate});
                        if(data) {
                            this.newName = ''; 
                            this.newNumber = ''; 
                            this.newPlate = '';
                            await this.loadList();
                        }
                    },
                    async finishStay(rowId) {
                        const data = await this.request("/HotelWebApp/api/hotel", "PUT", {id: rowId});
                        if(data) {
                            await this.loadList();
                        }
                    },
                    getPrice(beginStay) {
                        let begin = new Date(Date.parse(beginStay));
                        let ms = this.now - begin;
                        return this.hourPrice * ms / 60 / 60 / 1000;
                    }
                },
                mounted() {
                    this.loadList();
                    setInterval(() => {this.now = new Date();}, 1000);
                }
            });
            app.mount('#app');
        </script>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ENjdO4Dr2bkBIFxQpeoTz1HIcje39Wm4jDKdf19U8gI4ddQ3GYNS7NTKfAdVQSZe" crossorigin="anonymous"></script>
    </body>
</html>
