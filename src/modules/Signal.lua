--[[
# Signal

API-compatible Roblox events.

Addresses two flaws in previous implementations:

- Held a reference to the last set of fired arguments.
- Arguments would be overridden if the signal was fired by a listener.

## Synopsis

	- signal = Signal(function, function)

		Returns a new signal. Receives optional constructor and destructor
		functions. The constructor is called when the number of
		listeners/threads becomes greater than 0. The destructor is called
		when then number of threads/listeners becomes 0. The destructor
		receives as arguments the values returned by the constructor.

	- event = Signal:GetEvent()

		Get the signal's event object. Returns a SignalEvent.

	- event = Signal.Event

		API-compatible alias for GetEvent. Returns a SignalEvent.

	- Signal:Fire(...)

		Fire the signal, passing the arguments to each listener and waiting
		threads.

	- ... = Signal:Wait()

		Block the current thread until the signal is fired. Returns the
		arguments passed to Fire.

	- Signal:Destroy()

		Disconnects all listeners and becomes unassociated with currently
		blocked threads. The signal is still usable.

	- connection = SignalEvent:Connect(function)

		Sets a function to be called when the signal is fired. The listener
		function receives the arguments passed to Fire. Returns a
		SignalConnection.

	- SignalConnection:Disconnect()

		Disconnects the listener, causing it to no longer be called when the
		signal is fired.

	- bool =  SignalConnection:IsConnected()

		Returns whether the listener is connected.

	- bool = SignalConnection.Connected

		API-compatible alias for IsConnected.

]]

local function pack(...)
	return {n = select("#", ...), ...}
end

local mtSignalConnection = {__index={}}

function mtSignalConnection.__index:Disconnect()
	if self.conn then
		self.conn:Disconnect()
		self.conn = nil
	end
	if not self.signal then
		return
	end
	self.Connected = false
	local connections = self.signal.connections
	for i = 1, #connections do
		if connections[i] == self then
			table.remove(connections, i)
			break
		end
	end
	self.signal:destruct()
	self.signal = nil
end

function mtSignalConnection.__index:IsConnected()
	if self.conn then
		return self.conn.Connected
	end
	return false
end

----------------

local mtSignalEvent = {__index={}}

function mtSignalEvent.__index:Connect(listener)
	local signal = self.signal
	signal:construct()
	local conn = setmetatable({
		signal = signal,
		conn = signal.usignal.Event:Connect(function(id)
			local args = signal.args[id]
			args[1] = args[1] - 1
			if args[1] <= 0 then
				signal.args[id] = nil
			end
			listener(unpack(args[2], 1, args[2].n))
		end),
		Connected = true,
	}, mtSignalConnection)
	table.insert(signal.connections, conn)
	return conn
end

----------------

local mtSignal = {__index={}}

function mtSignal.__index:GetEvent()
	return self.event
end

function mtSignal.__index:Fire(...)
	local id = self.nextID
	self.nextID = self.nextID + 1
	self.args[id] = {#self.connections + self.threads, pack(...)}
	self.threads = 0
	self.usignal:Fire(id)
end

function mtSignal.__index:Wait()
	self.threads = self.threads + 1
	local id = self.usignal.Event:Wait()
	local args = self.args[id]
	args[1] = args[1] - 1
	if args[1] <= 0 then
		self.args[id] = nil
	end
	return unpack(args[2], 1, args[2].n)
end

function mtSignal.__index:Destroy()
	self.usignal:Destroy()
	self.usignal = Instance.new("BindableEvent")
	local connections = self.connections
	for i = #connections, 1, -1 do
		local conn = connections[i]
		conn.signal = nil
		conn.conn = nil
		conn.Connected = false
		connections[i] = nil
	end
	self.threads = 0
	self:destruct()
end

function mtSignal.__index:construct()
	if #self.connections > 0 then
		return
	end
	if self.ctor and not self.ctorData then
		self.ctorData = pack(self.ctor(self))
	end
end

function mtSignal.__index:destruct()
	if #self.connections > 0 then
		return
	end
	if self.dtor and self.ctorData then
		self.dtor(self, unpack(self.ctorData, 1, self.ctorData.n))
		self.ctorData = nil
	end
end

local function Signal(ctor, dtor)
	local self = {
		ctor        = ctor, -- Constructor function.
		dtor        = dtor, -- Destructor function.
		ctorData    = nil,  -- Values returned by ctor and passed dtor.
		args        = {},   -- Holds arguments for pending listener functions and threads. [id] = {#connections, #threads, {arguments}}
		nextID      = 0,    -- Holds the next args ID.
		connections = {},   -- SignalConnections connected to the signal.
		usignal     = Instance.new("BindableEvent"), -- Dispatches scheduler-compatible threads.
		threads     = 0,    -- Number of threads waiting on the signal.
	}
	self.event = setmetatable({signal = self}, mtSignalEvent)
	self.Event = self.event
	return setmetatable(self, mtSignal)
end

return Signal
