@extends('layouts.app')

@section('content')
<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card">
                <div class="card-header">Dashboard</div>

                <div class="card-body">
                    @if (session('status'))
                        <div class="alert alert-success" role="alert">
                            {{ session('status') }}
                        </div>
                    @endif

                    <p>
                        You are logged in on the new version!!
                    </p>

                    <form action="{{ route("home.store") }}" method="POST">
                        @csrf

                        <button class="btn btn-primary" type="submit">Dispatch the Example Job</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
@endsection
