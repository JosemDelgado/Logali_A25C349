const cds = require('@sap/cds');
require('dotenv').config();

module.exports = class LogaliGroup extends cds.ApplicationService {

    async init () {

        const {Products, Inventories, CBusinessPartner, CSuppliers, CCustomer} = this.entities;
        const cloud = await cds.connect.to("API_BUSINESS_PARTNER");
        const onpremise = await cds.connect.to("API_BUSINESS_PARTNER_CLUD");

        //cloud.run(UPDATE(CBusinessPartner));

        this.on('READ', CCustomer, async (req)=>{
            return await onpremise.tx(req).send({
                query: req.query,
                headers: {
                    authorization : process.env.AUTHORIZATION
                }
            })
        });

        this.on('READ', CBusinessPartner, async (req)=>{
            return await cloud.tx(req).send({
                query: req.query,
                headers: {
                    apikey : process.env.APIKEY
                }
            })
        });

        this.on('READ', CSuppliers, async (req)=>{

            return await cloud.tx(req).send({
                query: req.query,
                headers: {
                    apikey : process.env.APIKEY
                }
            })
        });

        this.before('NEW', Products.drafts, async (req) => {
            req.data.detail??= {
                baseUnit: 'EA',
                width: null,
                height: null,
                depth: null,
                weight: null,
                unitVolume: 'CM',
                unitWeight: 'KG'
            }
        });

        this.before('NEW', Inventories.drafts, async (req) => {

            let result = await SELECT.one.from(Inventories).columns('max(stockNumber) as max');
            let result2 = await SELECT.one.from(Inventories.drafts).columns('max(stockNumber) as max').where({product_ID: req.data.product_ID});
            
            let max = parseInt(result.max);
            let max2 = parseInt(result2.max);
            let newMax = 0;

            if (isNaN(max2)) {
                newMax = max + 1;
            } else if (max < max2) {
                newMax = max2 + 1;
            } else {
                newMax = max + 1; 
            }

            req.data.stockNumber = newMax.toString();
        });

        this.on('setStock', async (req) =>{
            const productId = req.params[0].ID;
            const inventoryId = req.params[1].ID;

            const amount = await SELECT.one.from(Inventories).columns('quantity').where({ID: inventoryId});
            let newAmount = 0;

            if (req.data.option === 'A') {
                console.log("Estoy dentro");
                newAmount = amount.quantity + req.data.amount;
                if (newAmount > 100) {  
                    await UPDATE(Products).set({statu_code: 'InStock'}).where({ID: productId});
                }

                await UPDATE(Inventories).set({quantity: newAmount}).where({ID: inventoryId});

                return req.info(200, `The amount ${req.data.amount} has benn added to the inventory`);
            } else if (req.data.amount > amount.quantity) {
                return req.error(400,`There is no availability for the requested quantity`);
            } else {
                newAmount = amount.quantity - req.data.amount;

                if (newAmount > 0 && newAmount <= 100 ) {
                    await UPDATE(Products).set({statu_code: 'LowAvailability'}).where({ID: productId});
                } else if  (newAmount === 0) {
                    await UPDATE(Products).set({statu_code: 'OutOfStock'}).where({ID: productId});
                }

                await UPDATE(Inventories).set({quantity: newAmount}).where({ID: inventoryId});
                return req.info(200, `The amount ${req.data.amount} has benn removed form the inventory`);
            }

        });


        return super.init();
    }

}