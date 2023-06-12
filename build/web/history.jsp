<%-- 
    Document   : index
    Created on : 4 de jun. de 2023, 22:37:51
    Author     : Acer Nitro 5
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Hotel</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-KK94CHFLLe+nY2dmCWGMq91rCGa5gtU4mk92HdvYe+M/SXH301p5ILy+dN9+nJOZ" crossorigin="anonymous">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
        <script src="https://unpkg.com/vue@next"></script>
    </head>
    <body>
        <%@include file="WEB-INF/jspf/header.jspf" %>
        
        <div id="app" class="container-fluid m-2">
            <div v-if="shared.session">
                <div v-if="error" class="alert alert-danger m-2" role="alert">
                    {{error}}
                </div>
                <div v-else>
                    <h2>Históricos</h2>
                    
                    <table class="table">
                        <tr>
                            <th>ID</th>
                            <th>PLACA</th>
                            <th>NOME</th>
                            <th>SUITE</th>
                            <th>ENTRADA</th>
                            <th>SAÍDA</th>
                            <th class="text-end">PREÇO</th>
                        </tr>
                        <tr v-for="item in list" :key="item.rowId">
                            <td>{{ item.rowId }}</td>
                            <td>{{ item.vehiclePlate }}</td>
                            <td>{{ item.customerName }}</td>
                            <td>{{ item.roomNumber }}</td>
                            <td>{{ item.beginStay }}</td>
                            <td>{{ item.endStay }}</td>
                            <td class="text-end">
                                {{ item.price.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' }) }}
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
        <script>
            const app = Vue.createApp({
                data() {
                    return {
                        shared: shared,
                        error: null,
                        now: new Date(),
                        newName: '', //newModel
                        newRoom: '', //newColor
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
                        const data = await this.request("/HotelWebApp/api/hotel?history", "GET");
                        if(data) {
                            this.hourPrice = data.hourPrice;
                            this.list = data.list;
                        }
                    },
                },
                mounted() {
                    this.loadList();
                }
            });
            app.mount('#app');
        </script>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ENjdO4Dr2bkBIFxQpeoTz1HIcje39Wm4jDKdf19U8gI4ddQ3GYNS7NTKfAdVQSZe" crossorigin="anonymous"></script>
    </body>
</html>