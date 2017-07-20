require "resources/mysql-async/lib/MySQL"

---------------------------------- FUNCTION ----------------------------------


-- FR -- Fonction : Permet d'ajouter une vente à la bourse, quand une ressource est vendu est doit être ajouté à la bourse
-- FR -- Paramètre(s) : id = ID de la ressource
---------------------------------------------------------
-- EN -- Function : Allows to add a sale to the stock exchange, when a resource is sold is to be added to the stock exchange
-- EN -- Param(s) :  id = ID resource
function addSell(id)
  MySQL.Async.execute("UPDATE stock_exchange SET sell = sell + 1 WHERE resource_id = @id", {['@id'] = id})
end


-- FR -- Fonction : Permet de récupérer le prix d'une ressource
-- FR -- Paramètre(s) : id = ID de la ressource
---------------------------------------------------------
-- EN -- Function : Allows get resource price
-- EN -- Param(s) :  id = ID resource
function whereIsPriceR(id)
  return MySQL.Sync.fetchScalar("SELECT price_current FROM stock_exchange WHERE resource_id = @id", {['@id'] = id})
end

RegisterServerEvent('Ilegal:GetPriceMeth')
AddEventHandler('Ilegal:GetPriceMeth', function(id)
    ActualPrice = whereIsPriceR(id)
    TriggerClientEvent("Ilegal:GotPriceMeth", -1, ActualPrice)
end)

RegisterServerEvent('Ilegal:GetPriceOrgan')
AddEventHandler('Ilegal:GetPriceOrgan', function(id)
    ActualPrice = whereIsPriceR(id)
    TriggerClientEvent("Ilegal:GotPriceOrgan", -1, ActualPrice)
end)

RegisterServerEvent('Ilegal:GetPriceWeed')
AddEventHandler('Ilegal:GetPriceWeed', function(id)
    ActualPrice = whereIsPriceR(id)
    TriggerClientEvent("Ilegal:GotPriceWeed", -1, ActualPrice)
end)

RegisterServerEvent('Ilegal:GetPriceCoke')
AddEventHandler('Ilegal:GetPriceCoke', function(id)
    ActualPrice = whereIsPriceR(id)
    TriggerClientEvent("Ilegal:GotPriceCoke", -1, ActualPrice)
end)

RegisterServerEvent('Ilegal:Sell')
AddEventHandler('Ilegal:Sell', function(id)
    addSell(id)
end)


-- FR -- CECI EST UN EXEMPLE D'UTILISATION DES FONCTIONS
-- EN -- THIS IS AN EXAMPLE OF USING FUNCTIONS
AddEventHandler("inventory:sell", function(id) -- Why not quantity ? Depending on your inventory system
    TriggerEvent('es:getPlayerFromId', source, function(user)
        whereIsPriceR(id, function (price) -- id = ID resource, You can pass your sync request to async with the callback
            -- MULTIPLE REQUEST : Inventory management, deletion of the item, update of the quantity, etc ...  Depending on your inventory system AGAAAIN
            user:addMoney(tonumber(price))
            addSell(id)
        end)
    end)
end)
